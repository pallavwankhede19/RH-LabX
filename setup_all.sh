#!/bin/bash

# -------------------- SSH & Ansible Setup --------------------
echo "[+] Starting sshd manually..."
/usr/sbin/sshd

echo "[+] Waiting for servers to boot up..."
sleep 15

# Generate SSH key for root if not already present
[ -f /root/.ssh/id_rsa ] || ssh-keygen -q -t rsa -N "" -f /root/.ssh/id_rsa

# SSH key distribution loop
for i in {1..4}; do
    echo "[+] Connecting to server$i..."
    until sshpass -p root ssh -o StrictHostKeyChecking=no root@server$i "hostname"; do
        echo "[-] Waiting for server$i SSH..."
        sleep 3
    done

    sshpass -p root ssh-copy-id -o StrictHostKeyChecking=no root@server$i
done

# Create Ansible inventory
cat <<EOF > /home/matthew/inventory.ini
[servers]
server1
server2
server3
server4
EOF

echo "[✓] Ansible setup complete."

# -------------------- LVM and Swap Setup --------------------
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

echo "[+] Formatting and mounting data volume..."
mkfs.xfs /dev/vg_lab/lv_data
mkdir -p /mnt/lvmdata
mount /dev/vg_lab/lv_data /mnt/lvmdata

echo "[+] Creating Logical Volume for swap..."
lvcreate -L 256M -n lv_swap vg_lab

echo "[+] Formatting and enabling swap..."
mkswap /dev/vg_lab/lv_swap
swapon /dev/vg_lab/lv_swap

echo "[+] Validation: swap status"
swapon --show
free -h

echo "[✓] LVM and swap setup completed successfully."

# -------------------- End of Script --------------------
exit 0

