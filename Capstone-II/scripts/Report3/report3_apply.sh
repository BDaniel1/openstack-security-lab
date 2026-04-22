#!/usr/bin/env bash
set -e

# ============================================================
# Report 3 apply script for enforcing project resource quotas
# Sets compute, storage, and network limits for dev and qa projects
# Simulates multi-tenant governance and resource control
# Prepares environment for quota validation and denial testing
# ============================================================

DEV_PROJECT="dev"
QA_PROJECT="qa"

echo "== Compute quotas =="

set +u
source /opt/stack/devstack/openrc admin admin
set -u

openstack quota set --instances 3 --cores 6 --ram 8192 $DEV_PROJECT
openstack quota set --instances 2 --cores 4 --ram 4096 $QA_PROJECT

echo "== Storage quotas =="

openstack quota set $DEV_PROJECT --volumes 3 --gigabytes 10
openstack quota set $QA_PROJECT --volumes 2 --gigabytes 5

echo "== Network quotas =="

openstack quota set $DEV_PROJECT --floating-ips 2
openstack quota set $QA_PROJECT --floating-ips 2
openstack quota set $DEV_PROJECT --secgroup-rules 20
openstack quota set $QA_PROJECT --secgroup-rules 10

echo "== Verification =="

echo "-- DEV quotas --"
openstack quota show $DEV_PROJECT

echo "-- QA quotas --"
openstack quota show $QA_PROJECT

echo "Report 3 apply complete."
