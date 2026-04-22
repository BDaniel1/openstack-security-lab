#!/usr/bin/env bash
set -e

# ============================================================
# Report 4 reset script for removing volume encryption configuration
# Detaches and deletes plain and encrypted volumes from the instance
# Deletes the custom encrypted volume type from Cinder
# Restores environment to pre-encryption state
# ============================================================

DEV_INSTANCE="DEV-APP"

PLAIN_VOL="dev-plain-volume"
SECURE_VOL="dev-secure-volume"
ENCRYPTED_TYPE="encrypted-luks"

echo "== Remove volumes =="

set +u
source /opt/stack/devstack/openrc admin dev
set -u

echo "Detaching and deleting secure volume"
openstack server remove volume $DEV_INSTANCE $SECURE_VOL || true
sleep 10
openstack volume delete $SECURE_VOL || true

echo "Detaching and deleting plain volume"
openstack server remove volume $DEV_INSTANCE $PLAIN_VOL || true
sleep 10
openstack volume delete $PLAIN_VOL || true

echo "== Remove encrypted type =="

set +u
source /opt/stack/devstack/openrc admin admin
set -u
openstack volume type delete $ENCRYPTED_TYPE || true

echo "== Verification =="

set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack volume list || true

set +u
source /opt/stack/devstack/openrc admin admin
set -u
openstack volume type list || true

echo "Report 4 reset complete."
