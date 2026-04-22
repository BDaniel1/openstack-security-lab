#!/usr/bin/env bash
set -e

# ============================================================
# Transition script from Report 1 hardened RBAC to Lab 2 baseline
# Removes custom roles, groups, and policy enforcement from Report 1
# Restores direct default role assignments for Labs 2–5
# Prepares environment for continued lab progression
# ============================================================

DEV_PROJECT="dev"
QA_PROJECT="qa"

DEV_USER="DevUser1"
QA_USER="QAUser1"
AUDITOR_USER="Auditor1"
ADMIN_USER="admin"

NOVA_POLICY_FILE="/etc/nova/policy.yaml"
NOVA_CONF_FILE="/etc/nova/nova.conf"
GLANCE_POLICY_FILE="/etc/glance/policy.yaml"
GLANCE_API_CONF="/etc/glance/glance-api.conf"

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this script as root or with sudo."
  exit 1
fi

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

set +u
source /opt/stack/devstack/openrc admin admin
set -u

echo "== Removing Report 1 custom group role assignments =="
openstack role remove --project "$DEV_PROJECT" --group DevTeam dev_compute || true
openstack role remove --project "$DEV_PROJECT" --group AuditTeam audit_read || true
openstack role remove --project "$QA_PROJECT" --group QATeam qa_compute || true
openstack role remove --project "$QA_PROJECT" --group AuditTeam audit_read || true

echo "== Removing users from Report 1 groups =="
openstack group remove user DevTeam "$DEV_USER" || true
openstack group remove user QATeam "$QA_USER" || true
openstack group remove user AuditTeam "$AUDITOR_USER" || true

echo "== Deleting Report 1 groups =="
openstack group delete DevTeam || true
openstack group delete QATeam || true
openstack group delete AuditTeam || true

echo "== Deleting Report 1 custom roles =="
openstack role delete dev_compute || true
openstack role delete qa_compute || true
openstack role delete audit_read || true

echo "== Removing any old direct default-role assignments =="
openstack role remove --project "$DEV_PROJECT" --user "$DEV_USER" member || true
openstack role remove --project "$DEV_PROJECT" --user "$AUDITOR_USER" reader || true
openstack role remove --project "$DEV_PROJECT" --user "$ADMIN_USER" admin || true

openstack role remove --project "$QA_PROJECT" --user "$QA_USER" member || true
openstack role remove --project "$QA_PROJECT" --user "$AUDITOR_USER" reader || true
openstack role remove --project "$QA_PROJECT" --user "$ADMIN_USER" admin || true

echo "== Rebuilding direct default-role assignments for Labs 2-5 =="
openstack role add --project "$DEV_PROJECT" --user "$DEV_USER" member
openstack role add --project "$DEV_PROJECT" --user "$AUDITOR_USER" reader
openstack role add --project "$DEV_PROJECT" --user "$ADMIN_USER" admin

openstack role add --project "$QA_PROJECT" --user "$QA_USER" member
openstack role add --project "$QA_PROJECT" --user "$AUDITOR_USER" reader
openstack role add --project "$QA_PROJECT" --user "$ADMIN_USER" admin

echo "== Removing Report 1 Nova/Glance custom policy references =="
remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "policy_file"
remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "enforce_scope"
remove_conf_key "$NOVA_CONF_FILE" "oslo_policy" "enforce_new_defaults"

remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "policy_file"
remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "enforce_scope"
remove_conf_key "$GLANCE_API_CONF" "oslo_policy" "enforce_new_defaults"

echo "== Removing Report 1 custom policy files =="
rm -f "$NOVA_POLICY_FILE" "$GLANCE_POLICY_FILE"

echo "== Restarting services =="
systemctl daemon-reload || true
systemctl restart devstack@n-api
systemctl restart devstack@n-cpu
systemctl restart devstack@g-api

echo "Waiting for Services to stabilize..."
sleep 10

echo "== Final verification =="
echo "-- ${DEV_PROJECT} role assignments --"
openstack role assignment list --project "$DEV_PROJECT" --names || true
echo "-- ${QA_PROJECT} role assignments --"
openstack role assignment list --project "$QA_PROJECT" --names || true

echo
echo "Script complete."
echo "Expected end state:"
echo "  ${DEV_USER}     -> member in ${DEV_PROJECT}"
echo "  ${QA_USER}      -> member in ${QA_PROJECT}"
echo "  ${AUDITOR_USER} -> reader in ${DEV_PROJECT} and ${QA_PROJECT}"
echo "  ${ADMIN_USER}   -> admin in ${DEV_PROJECT} and ${QA_PROJECT}"
