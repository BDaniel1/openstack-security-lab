#!/usr/bin/env bash
set -e

# ============================================================
# Report 3 reset script for restoring default project quotas
# Resets compute, storage, and network limits for dev and qa
# Removes enforced constraints from quota testing phase
# Returns environment to pre-governance baseline state
# ============================================================

DEV_PROJECT="dev"
QA_PROJECT="qa"

set +u
source /opt/stack/devstack/openrc admin admin
set -u

echo "== Reset compute quotas =="
openstack quota set --instances 10 --cores 20 --ram 51200 $DEV_PROJECT
openstack quota set --instances 10 --cores 20 --ram 51200 $QA_PROJECT

echo "== Reset storage quotas =="
openstack quota set $DEV_PROJECT --volumes 10 --gigabytes 10
openstack quota set $QA_PROJECT --volumes 10 --gigabytes 5

echo "== Reset network quotas =="
openstack quota set $DEV_PROJECT --floating-ips 10
openstack quota set $QA_PROJECT --floating-ips 10
openstack quota set $DEV_PROJECT --secgroup-rules 100
openstack quota set $QA_PROJECT --secgroup-rules 100

echo "== Verification =="

echo "-- DEV quotas --"
openstack quota show $DEV_PROJECT

echo "-- QA quotas --"
openstack quota show $QA_PROJECT

echo "Report 3 reset complete."
