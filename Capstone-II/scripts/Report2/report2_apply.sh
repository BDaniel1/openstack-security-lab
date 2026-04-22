#!/usr/bin/env bash
set -e

# ============================================================
# Report 2 apply script for network segmentation and tenant isolation
# Creates project networks, subnets, routers, and security groups
# Moves VMs from shared networking into dev and qa environments
# Applies access controls and restores connectivity with floating IPs
# ============================================================

PUBLIC_NET="shared"
#EXTERNAL_NET="public"

DEV_NET="dev-net"
DEV_SUBNET="dev-subnet"
DEV_CIDR="10.0.20.0/24"
DEV_ROUTER="dev-router"
DEV_SECGRP="dev-secgroup"

TEST_NET="test-net"
TEST_SUBNET="test-subnet"
TEST_CIDR="10.0.10.0/24"
TEST_ROUTER="test-router"
TEST_SECGRP="test-secgroup"

DEV_VMS=("DEV-APP" "DEV-DB")
TEST_VMS=("TEST-APP" "TEST-DB")

echo "== DEV network setup =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack network create $DEV_NET
openstack subnet create $DEV_SUBNET --network $DEV_NET --subnet-range $DEV_CIDR
sleep 3

echo "== TEST network setup =="
set +u
source /opt/stack/devstack/openrc admin qa
set -u
openstack network create $TEST_NET
openstack subnet create $TEST_SUBNET --network $TEST_NET --subnet-range $TEST_CIDR
sleep 3

echo "== Move DEV VMs =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    openstack server stop $vm || true
    sleep 10
    openstack server remove network $vm $PUBLIC_NET || true
    sleep 3
    openstack server add network $vm $DEV_NET || true
    sleep 3
done

echo "== Move TEST VMs =="
set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    openstack server stop $vm || true
    sleep 10
    openstack server remove network $vm $PUBLIC_NET || true
    sleep 3
    openstack server add network $vm $TEST_NET || true
    sleep 3
done

echo "== Routers =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack router create $DEV_ROUTER
sleep 2
openstack router set $DEV_ROUTER --external-gateway public
sleep 2
openstack router add subnet $DEV_ROUTER $DEV_SUBNET
sleep 2

set +u
source /opt/stack/devstack/openrc admin qa
set -u
openstack router create $TEST_ROUTER
sleep 2
openstack router set $TEST_ROUTER --external-gateway public
sleep 2
openstack router add subnet $TEST_ROUTER $TEST_SUBNET
sleep 2

echo "== Security Groups =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
openstack security group create $DEV_SECGRP
openstack security group rule create --ingress --protocol tcp --dst-port 22 $DEV_SECGRP
openstack security group rule create --ingress --protocol icmp $DEV_SECGRP
openstack security group rule create --ingress --protocol tcp --dst-port 80 $DEV_SECGRP

set +u
source /opt/stack/devstack/openrc admin qa
set -u
openstack security group create $TEST_SECGRP
openstack security group rule create --ingress --protocol tcp --dst-port 22 $TEST_SECGRP
openstack security group rule create --ingress --protocol icmp $TEST_SECGRP

echo "== Apply security groups =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    openstack server add security group $vm $DEV_SECGRP || true
    openstack server remove security group $vm default || true
done

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    openstack server add security group $vm $TEST_SECGRP || true
    openstack server remove security group $vm default || true
done

echo "== Start instances =="
set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    openstack server start $vm || true
    sleep 10
done

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    openstack server start $vm || true
    sleep 10
done

echo "== Floating IPs =="

set +u
source /opt/stack/devstack/openrc admin qa
set -u
for vm in "${TEST_VMS[@]}"; do
    NEW_FIP=$(openstack floating ip create public -f value -c floating_ip_address)
    echo "Created floating IP for $vm: $NEW_FIP"
    read -p "Enter floating IP for $vm: " FIP
    openstack server add floating ip "$vm" "$FIP" || true
    echo "$vm -> $FIP"
done

set +u
source /opt/stack/devstack/openrc admin dev
set -u
for vm in "${DEV_VMS[@]}"; do
    NEW_FIP=$(openstack floating ip create public -f value -c floating_ip_address)
    echo "Created floating IP for $vm: $NEW_FIP"
    read -p "Enter floating IP for $vm: " FIP
    openstack server add floating ip "$vm" "$FIP" || true
    echo "$vm -> $FIP"
done

echo "Report 2 apply complete."
