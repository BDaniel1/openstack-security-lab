#!/usr/bin/env bash
set -e

# ============================================================
# VM creation script for the Report 2 lab environment
# Deploys two dev VMs and two qa VMs on the shared network
# Uses Cirros and m1.tiny for lightweight test instances
# Prepares compute resources for later segmentation and policy steps
# ============================================================

echo "== Creating DEV VMs =="

set +u
source /opt/stack/devstack/openrc admin dev
set -u

openstack server create \
  --image cirros-0.6.3-x86_64-disk \
  --flavor m1.tiny \
  --network shared \
  DEV-APP

openstack server create \
  --image cirros-0.6.3-x86_64-disk \
  --flavor m1.tiny \
  --network shared \
  DEV-DB


echo "== Creating QA VMs =="

set +u
source /opt/stack/devstack/openrc admin qa
set -u

openstack server create \
  --image cirros-0.6.3-x86_64-disk \
  --flavor m1.tiny \
  --network shared \
  TEST-APP

openstack server create \
  --image cirros-0.6.3-x86_64-disk \
  --flavor m1.tiny \
  --network shared \
  TEST-DB


echo "== VM Creation Submitted =="

echo "Waiting for VMs to become ACTIVE..."
sleep 10

echo
echo "== Verification: DEV Project =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack server list

echo
echo "== Verification: QA Project =="
set +u
source /opt/stack/devstack/openrc admin qa
set -u
openstack server list

echo
echo "Verification complete."