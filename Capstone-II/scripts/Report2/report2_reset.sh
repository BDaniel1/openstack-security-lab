#!/usr/bin/env bash
set -e

# ============================================================
# Report 2 reset script for returning to the post-VM baseline state
# Removes floating IPs, custom security groups, routers, and tenant networks
# Moves dev and qa VMs back to the shared network
# Restores the environment to the end of Section 1 for continued lab setup
# ============================================================

PUBLIC_NET="shared"

DEV_NET="dev-net"
DEV_SUBNET="dev-subnet"
DEV_ROUTER="dev-router"
DEV_SECGRP="dev-secgroup"

TEST_NET="test-net"
TEST_SUBNET="test-subnet"
TEST_ROUTER="test-router"
TEST_SECGRP="test-secgroup"

DEV_VMS=("DEV-APP" "DEV-DB")
TEST_VMS=("TEST-APP" "TEST-DB")

remove_fips() {
    vm=$1
    openstack server show "$vm" -c addresses
    read -p "Enter floating IP to remove from $vm (or press Enter to skip): " FIP
    if [[ -n "$FIP" ]]; then
        openstack server remove floating ip "$vm" "$FIP" || true
        sleep 2
        openstack floating ip delete "$FIP" || true
        sleep 2
    fi
}

echo "== Remove floating IPs =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    remove_fips $vm || true
done

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    remove_fips $vm || true
done

echo "== Restore security groups =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    openstack server add security group $vm default || true
    sleep 2
    openstack server remove security group $vm $DEV_SECGRP || true
    sleep 2
done
openstack security group delete $DEV_SECGRP || true

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    openstack server add security group $vm default || true
    sleep 2
    openstack server remove security group $vm $TEST_SECGRP || true
    sleep 2
done
openstack security group delete $TEST_SECGRP || true

echo "== Move VMs back to public =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    openstack server stop $vm || true
    sleep 10
    openstack server add network $vm $PUBLIC_NET || true
    sleep 3
    openstack server remove network $vm $DEV_NET || true
    sleep 3
    openstack server start $vm || true
    sleep 10
done

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    openstack server stop $vm || true
    sleep 10
    openstack server add network $vm $PUBLIC_NET || true
    sleep 3
    openstack server remove network $vm $TEST_NET || true
    sleep 3
    openstack server start $vm || true
    sleep 10
done

echo "== Remove routers =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack router remove subnet $DEV_ROUTER $DEV_SUBNET || true
sleep 2
openstack router unset --external-gateway $DEV_ROUTER || true
sleep 2
openstack router delete $DEV_ROUTER || true

set +u
source /opt/stack/devstack/openrc admin qa
set -u
openstack router remove subnet $TEST_ROUTER $TEST_SUBNET || true
sleep 2
openstack router unset --external-gateway $TEST_ROUTER || true
sleep 2
openstack router delete $TEST_ROUTER || true

echo "== Remove networks =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
sleep 3
openstack subnet delete $DEV_SUBNET || true
sleep 2
openstack network delete $DEV_NET || true

set +u
source /opt/stack/devstack/openrc admin qa
set -u
sleep 3
openstack subnet delete $TEST_SUBNET || true
sleep 2
openstack network delete $TEST_NET || true

echo "Report 2 reset complete."
