#!/usr/bin/env bash
set -e

# ============================================================
# Report 4 apply script for Cinder volume encryption validation
# Creates and attaches both plain and LUKS-encrypted volumes
# Configures encrypted volume type using the LVM backend
# Demonstrates data-at-rest protection in the dev environment
# ============================================================

DEV_INSTANCE="DEV-APP"

PLAIN_VOL="dev-plain-volume"
SECURE_VOL="dev-secure-volume"
ENCRYPTED_TYPE="encrypted-luks"

PLAIN_SIZE_GB=1
SECURE_SIZE_GB=1

VOLUME_BACKEND_NAME="lvmdriver-1"

echo "== Create plain volume =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack volume create --size $PLAIN_SIZE_GB $PLAIN_VOL || true

sleep 3

echo "== Attach plain volume =="
openstack server add volume $DEV_INSTANCE $PLAIN_VOL || true

echo "== Create encrypted type =="
set +u
source /opt/stack/devstack/openrc admin admin
set -u
openstack volume type create $ENCRYPTED_TYPE || true

openstack volume type set $ENCRYPTED_TYPE   --property volume_backend_name=$VOLUME_BACKEND_NAME

openstack volume type set $ENCRYPTED_TYPE   --encryption-provider luks   --encryption-cipher aes-xts-plain64   --encryption-key-size 256   --encryption-control-location front-end || true

echo "== Create encrypted volume =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack volume create --size $SECURE_SIZE_GB --type $ENCRYPTED_TYPE $SECURE_VOL || true

sleep 3

echo "== Attach encrypted volume =="
openstack server add volume $DEV_INSTANCE $SECURE_VOL || true

echo "== Verification =="
openstack volume show $PLAIN_VOL || true
openstack volume show $SECURE_VOL || true

set +u
source /opt/stack/devstack/openrc admin admin
set -u
openstack volume type show $ENCRYPTED_TYPE || true

echo "Report 4 apply complete."
