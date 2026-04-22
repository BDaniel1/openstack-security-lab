#!/usr/bin/env bash
set -eo pipefail

# ============================================================
# Report 1 reset script for returning to baseline access controls
# Removes custom roles, groups, and policy enforcement from Report 1
# Restores direct baseline user role assignments in dev and qa
# Returns the environment to the original pre-hardening state
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

remove_conf_key() {
  local file="$1"
  local section="$2"
  local key="$3"

  python3 - "$file" "$section" "$key" <<'PY'
import configparser
import sys
from pathlib import Path

file_path = Path(sys.argv[1])
section = sys.argv[2]
key = sys.argv[3]

if not file_path.exists():
    raise SystemExit(0)

cfg = configparser.ConfigParser()
cfg.optionxform = str
cfg.read(file_path)

if section in cfg and key in cfg[section]:
    del cfg[section][key]
    if not cfg[section]:
        del cfg[section]

with file_path.open("w") as f:
    cfg.write(f)
PY
}

main() {
  require_root

  echo "== Removing custom group role assignments =="
  openstack role remove --project dev --group DevTeam dev_compute || true
  openstack role remove --project dev --group AuditTeam audit_read || true
  openstack role remove --project qa --group QATeam qa_compute || true
  openstack role remove --project qa --group AuditTeam audit_read || true

  echo "== Restoring direct baseline user role assignments =="
  openstack role add --project dev --user DevUser1 member || true
  openstack role add --project dev --user Auditor1 reader || true
  openstack role add --project qa --user QAUser1 member || true
  openstack role add --project qa --user Auditor1 reader || true

  echo "== Removing users from groups =="
  openstack group remove user DevTeam DevUser1 || true
  openstack group remove user QATeam QAUser1 || true
  openstack group remove user AuditTeam Auditor1 || true

  echo "== Deleting groups =="
  openstack group delete DevTeam || true
  openstack group delete QATeam || true
  openstack group delete AuditTeam || true

  echo "== Deleting custom roles =="
  openstack role delete dev_compute || true
  openstack role delete qa_compute || true
  openstack role delete audit_read || true

  echo "== Removing Nova/Glance custom policy references =="
  remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "policy_file"
  remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "enforce_scope"
  remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "enforce_new_defaults"

  remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "policy_file"
  remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "enforce_scope"
  remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "enforce_new_defaults"

  echo "== Removing custom policy files =="
  rm -f "$NOVA_POLICY_FILE" "$GLANCE_POLICY_FILE"

  echo "== Restarting services =="
  systemctl daemon-reload || true
  systemctl restart devstack@n-api || true
  systemctl restart devstack@n-cpu || true
  systemctl restart devstack@g-api || true

  echo "== Final verification =="
  echo "-- dev project role assignments --"
  openstack role assignment list --project dev --names || true
  echo "-- qa project role assignments --"
  openstack role assignment list --project qa --names || true

  echo "Reset script complete."
}

main "$@"
