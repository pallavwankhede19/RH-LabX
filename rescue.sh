#!/bin/bash

echo "[+] Creating dummy file for LVM..."
dd if=/dev/zero of=/lvm_disk.img bs=1M count=1024

echo "[+] Setting up loop device..."
losetup /dev/loop10 /lvm_disk.img

echo "[+] Creating Physical Volume..."
pvcreate /dev/loop10

echo "[+] Creating Volume Group..."
vgcreate vg_lab /dev/loop10

echo "[+] Creating Logical Volume for data..."
lvcreate -L 512M -n lv_data vg_lab

echo "[+] Formatting and mounting..."
mkfs.xfs /dev/vg_lab/lv_data
mkdir -p /mnt/lvmdata
mount /dev/vg_lab/lv_data /mnt/lvmdata

echo "[+] Creating Logical Volume for swap..."
lvcreate -L 256M -n lv_swap vg_lab

echo "[+] Formatting swap volume..."
mkswap /dev/vg_lab/lv_swap
swapon /dev/vg_lab/lv_swap

echo "[+] Validation: swap status"
swapon --show
free -h

echo "[✓] LVM and swap setup completed successfully."

