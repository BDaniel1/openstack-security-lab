#!/usr/bin/env bash
set -e

# ============================================================
# Cinder repair script for restoring block storage functionality
# Rebinds the correct loop device to the Cinder LVM volume group
# Updates LVM filtering and restarts the c-vol service
# Used before Labs 2–5 when block storage is unavailable
# ============================================================

CINDER_CONF="/etc/cinder/cinder.conf"
LVM_CONF="/etc/lvm/lvm.conf"
CINDER_SERVICE="devstack@c-vol"

echo "=== Current loop devices ==="
losetup -a || true
echo

read -p "Enter loop device number (example: 14): " LOOP_NUM

LOOP_DEV="/dev/loop${LOOP_NUM}"

echo "Using: $LOOP_DEV"

# Get VG name
VG_NAME=$(grep volume_group $CINDER_CONF | awk -F= '{print $2}' | tr -d ' ')

echo "Volume Group: $VG_NAME"
echo

# Backup config
sudo cp "$LVM_CONF" "${LVM_CONF}.bak"

# Update LVM global_filter to selected loop device
sudo sed -i "s#^[[:space:]]*global_filter.*#global_filter = [ \"a|loop${LOOP_NUM}|\", \"r|.*|\" ]#" /etc/lvm/lvm.conf

echo "Updated LVM filter:"
grep global_filter "$LVM_CONF"

sudo pvscan --cache
sudo vgscan --cache

# Setup PV
sudo pvcreate $LOOP_DEV -ff -y || true

# Setup VG
sudo vgcreate $VG_NAME $LOOP_DEV || true

# Restart Cinder
systemctl daemon-reload || true
sudo systemctl restart $CINDER_SERVICE

echo
echo "=== Service Status ==="
systemctl status $CINDER_SERVICE --no-pager || true

echo "Waiting for Cinder to stabilize..."
sleep 10

echo
read -p "Create test volume? (y/n): " TEST

if [[ "$TEST" == "y" ]]; then
    set +u
    source /opt/stack/devstack/openrc admin admin
    set -u
    openstack volume create --size 1 test-volume || true
    openstack volume list
fi

echo
echo "Cinder repair complete."
