#!/usr/bin/env bash
set -eo pipefail

# =========================================================
# OpenStack baseline setup for Capstone II labs
# Creates dev/qa projects and DevUser1, QAUser1, Auditor1 users
# Applies RBAC roles (member, reader, admin) across projects
# Starting point only — no VMs are created
# =========================================================

DEV_USER="DevUser1"
AUDITOR_USER="Auditor1"
QA_USER="QAUser1"

DEV_PROJECT="dev"
QA_PROJECT="qa"

DEV_PASS="password"
AUDITOR_PASS="password"
QA_PASS="password"

echo "Starting OpenStack baseline environment setup..."

set +u
source /opt/stack/devstack/openrc admin admin
set -u

openstack project create "$DEV_PROJECT"
openstack project create "$QA_PROJECT"

openstack user create --password "$DEV_PASS" "$DEV_USER"
openstack user create --password "$AUDITOR_PASS" "$AUDITOR_USER"
openstack user create --password "$QA_PASS" "$QA_USER"

openstack role add --project "$DEV_PROJECT" --user "$AUDITOR_USER" reader
openstack role add --project "$QA_PROJECT" --user "$AUDITOR_USER" reader

openstack role add --project "$DEV_PROJECT" --user "$DEV_USER" member
openstack role add --project "$QA_PROJECT" --user "$QA_USER" member

openstack role add --project "$DEV_PROJECT" --user admin admin
openstack role add --project "$QA_PROJECT" --user admin admin

echo
echo "Baseline environment setup complete."
echo "No VM instances were created."
