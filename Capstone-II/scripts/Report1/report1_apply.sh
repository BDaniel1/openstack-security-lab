#!/usr/bin/env bash
set -eo pipefail

# ============================================================
# Report 1 apply script for RBAC hardening
# Creates custom roles/groups and enforces least-privilege access
# Applies Nova/Glance policy changes and restarts services
# Transitions baseline environment to Report 1 final state
# ============================================================

NOVA_POLICY_FILE="${NOVA_POLICY_FILE:-/etc/nova/policy.yaml}"
NOVA_CONF_FILE="${NOVA_CONF_FILE:-/etc/nova/nova.conf}"
GLANCE_POLICY_FILE="${GLANCE_POLICY_FILE:-/etc/glance/policy.yaml}"
GLANCE_API_CONF="${GLANCE_API_CONF:-/etc/glance/glance-api.conf}"

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "Run this script as root or with sudo."
    exit 1
  fi
}

set +u
source /opt/stack/devstack/openrc admin admin
set -u

ensure_conf_kv() {
  local file="$1"
  local section="$2"
  local key="$3"
  local value="$4"

  python3 - "$file" "$section" "$key" "$value" <<'PY'
import configparser
import sys
from pathlib import Path

file_path = Path(sys.argv[1])
section = sys.argv[2]
key = sys.argv[3]
value = sys.argv[4]

cfg = configparser.ConfigParser()
cfg.optionxform = str

if file_path.exists():
    cfg.read(file_path)

if section not in cfg:
    cfg[section] = {}

cfg[section][key] = value

with file_path.open("w") as f:
    cfg.write(f)
PY
}

write_nova_policy() {
  mkdir -p "$(dirname "$NOVA_POLICY_FILE")"
  cat > "$NOVA_POLICY_FILE" <<'POLICYEOF'
# Custom Nova policy for Report 1 RBAC hardening
# Dev role: full instance lifecycle
# QA role: read + reboot only
# Auditor role: read-only

"context_is_admin": "role:admin"
"admin_or_owner": "is_admin:True or project_id:%(project_id)s"
"admin_api": "role:admin"

"compute:get_all": "role:admin or role:dev_compute or role:qa_compute or role:audit_read"
"compute:get": "role:admin or role:dev_compute or role:qa_compute or role:audit_read"

"compute:create": "role:admin or role:dev_compute"
"compute:create:attach_network": "role:admin or role:dev_compute"

"compute:delete": "role:admin or role:dev_compute"

"compute:start": "role:admin or role:dev_compute"
"compute:stop": "role:admin or role:dev_compute"
"compute:reboot": "role:admin or role:dev_compute or role:qa_compute"

"compute:rebuild": "role:admin or role:dev_compute"
"compute:resize": "role:admin or role:dev_compute"
"compute:shelve": "role:admin or role:dev_compute"
"compute:unshelve": "role:admin or role:dev_compute"

"os_compute_api:servers:index": "role:admin or role:dev_compute or role:qa_compute or role:audit_read"
"os_compute_api:servers:detail": "role:admin or role:dev_compute or role:qa_compute or role:audit_read"
"os_compute_api:servers:create": "role:admin or role:dev_compute"
"os_compute_api:servers:delete": "role:admin or role:dev_compute"
"os_compute_api:os-server-actions:reboot": "role:admin or role:dev_compute or role:qa_compute"
POLICYEOF
  chmod 640 "$NOVA_POLICY_FILE"
}

write_glance_policy() {
  mkdir -p "$(dirname "$GLANCE_POLICY_FILE")"
  cat > "$GLANCE_POLICY_FILE" <<'POLICYEOF'
# Minimal Glance policy from Report 1:
# allow dev_compute and admin to retrieve image details
"get_image": "role:admin or role:dev_compute"
"get_images": "role:admin or role:dev_compute"
POLICYEOF
  chmod 640 "$GLANCE_POLICY_FILE"
}

main() {
  require_root

  echo "== Creating custom roles =="
  openstack role create dev_compute || true
  openstack role create qa_compute || true
  openstack role create audit_read || true

  echo "== Creating groups =="
  openstack group create DevTeam || true
  openstack group create QATeam || true
  openstack group create AuditTeam || true

  echo "== Adding users to groups =="
  openstack group add user DevTeam DevUser1 || true
  openstack group add user QATeam QAUser1 || true
  openstack group add user AuditTeam Auditor1 || true

  echo "== Removing direct default user role assignments =="
  openstack role remove --project dev --user DevUser1 member || true
  openstack role remove --project dev --user Auditor1 reader || true
  openstack role remove --project qa --user QAUser1 member || true
  openstack role remove --project qa --user Auditor1 reader || true

  echo "== Assigning custom roles to groups =="
  openstack role add --project dev --group DevTeam dev_compute || true
  openstack role add --project dev --group AuditTeam audit_read || true
  openstack role add --project qa --group QATeam qa_compute || true
  openstack role add --project qa --group AuditTeam audit_read || true

  echo "== Writing Nova policy file =="
  write_nova_policy

  echo "== Configuring Nova to use custom policy =="
  ensure_conf_kv "$NOVA_CONF_FILE" "oslo_policy" "policy_file" "$NOVA_POLICY_FILE"
  ensure_conf_kv "$NOVA_CONF_FILE" "oslo_policy" "enforce_scope" "true"
  ensure_conf_kv "$NOVA_CONF_FILE" "oslo_policy" "enforce_new_defaults" "true"

  echo "== Writing Glance policy file =="
  write_glance_policy

  echo "== Configuring Glance to use custom policy =="
  ensure_conf_kv "$GLANCE_API_CONF" "oslo_policy" "policy_file" "$GLANCE_POLICY_FILE"
  ensure_conf_kv "$GLANCE_API_CONF" "oslo_policy" "enforce_scope" "true"
  ensure_conf_kv "$GLANCE_API_CONF" "oslo_policy" "enforce_new_defaults" "true"

  echo "== Restarting services =="
  systemctl daemon-reload || true
  systemctl restart devstack@n-api || true
  systemctl restart devstack@n-cpu || true
  systemctl restart devstack@g-api || true

  echo "== Final verification =="
  openstack role list | egrep 'dev_compute|qa_compute|audit_read' || true
  openstack group list | egrep 'DevTeam|QATeam|AuditTeam' || true
  echo "-- dev project role assignments --"
  openstack role assignment list --project dev --names || true
  echo "-- qa project role assignments --"
  openstack role assignment list --project qa --names || true

  echo "Apply script complete."
}
main "$@"
