#!/bin/bash
#
# sys_setup.sh
# Configure system for the first time
#
# 24.11.2020
# Daniel Selvan, Jasmin Infotech

# Lowering the kernel print
echo "Reducing kernel logging level"
echo "kernel.printk = 2 2 0 2" >/etc/sysctl.d/klog.conf

###################################################################################################

#           Configuring Integrity block

###################################################################################################

integritysetup="/usr/sbin/integritysetup"
keylen=4 # Currently supporting this only.

integrity_blk="/dev/mmcblk1p4" # For SD Card
# integrity_blk="/dev/mmcblk0p4" # For eMMC

[ -e integrity_blk ] && {
    # (Optional) unmounting & closing the authenticated block
    umount /home
    $integritysetup close ihome

    rm -f /data/itr.key 2>/dev/null

    # Creating a key file
    tr -dc A-Za-z0-9 </dev/urandom | head -c $keylen >/data/itr.key

    # Deny any access for other users than root(read only)
    chmod 400 /data/itr.key

    # Format the device with default standalone mode (CRC32C)
    echo -n "YES" | $integritysetup format --integrity-key-size $keylen --integrity-key-file /data/itr.key integrity_blk -

    # Open the device with default parameters
    $integritysetup open --integrity-key-size $keylen --integrity-key-file /data/itr.key integrity_blk ihome
    mkfs.ext4 -b 4096 /dev/mapper/ihome # Creating ext4 filesystem in authenticated block
    rm -rf /home 2>/dev/null            # Deleting old home
    mkdir -p /home                      # Creating mount point
    mount /dev/mapper/ihome /home       # Mounting authenticated home dir
    mkdir -m 700 -p /home/root          # Creating home directory for root

    echo "Creating auto mount service"

    cat >/usr/ihome.sh <<EOF
#!/bin/bash
$integritysetup open --integrity-key-size $keylen --integrity-key-file /data/itr.key integrity_blk ihome
# Creating mount point
mkdir -p /home
# Mounting authenticated home dir
/bin/mount -t ext4 /dev/mapper/ihome /home/
EOF

    # Deny access for others
    chmod 500 /usr/ihome.sh

    cat >/etc/systemd/system/ihome.service <<EOF
[Unit]
Description=Authenticated home directory
DefaultDependencies=no
Conflicts=shutdown.target
After=local-fs.target
OnFailure=emergency.target
OnFailureJobMode=replace-irreversibly
Before=rc-local.service
[Service]
Type=oneshot
ExecStart=/usr/ihome.sh
TimeoutStartSec=90
[Install]
WantedBy=default.target
RequiredBy=rc-local.service systemd-logind.service
EOF

    # Deny access for others (Read Only)
    chmod 644 /etc/systemd/system/ihome.service

    echo Enabling auto mount service
    systemctl daemon-reload
    systemctl enable ihome.service

    # Service status check
    # systemctl status ihome

    ###################################################################################################
} || echo Proceeding without creating authenticated home

###################################################################################################
#
#       Script to create show-info
#
###################################################################################################

cat >/usr/bin/show-info <<EOF
#!/bin/bash
# /usr/bin/show-info
# Created by Daniel on 16.07.2020
# Display secure boot status
title="Secure Boot Info"
sec_info="\\
Version\n\\
1. Uboot : \$(fw_printenv --version 2>&1 | cut -d'-' -f2 | cut -d' ' -f2)\n\\
2. Kernel: \$(cut -d'-' -f1 /proc/version | cut -d' ' -f3)\n\\
3. Mender: \$(mender -v | cut -f1)\n\\
\n\\
HAB Status\n\\
1. Uboot : Authenticated\n\\
2. Kernel: Authenticated\n\\
\n\\
Mender: Running with process ID \$(pidof mender)\\
"
clear
whiptail \
    --title "\$title" \
    --msgbox "\$sec_info" \
    18 50
clear
exit 0
EOF

chmod 100 /usr/bin/show-info

if [ -f /etc/profile ]; then
    cat >>/etc/profile <<EOF
# Modified by Daniel on 16.07.2020
# FILE exists and execute
if [[ -x /usr/bin/show-info ]]; then
  /usr/bin/show-info
fi
EOF
fi
###################################################################################################

cat >/usr/bin/delete-service <<EOF
#!/bin/bash
#
# /usr/bin/delete-service
# Created by Daniel Selvan on 27.07.2020
# Delete the mentioned service
#
[ \$1 = "" ] && {
    echo Pass the service name to be deleted.
    exit 1
}
service_tbd=\$1 # Service name to be deleted
systemctl stop \$service_tbd 2>/dev/null 
systemctl disable \$service_tbd 2>/dev/null 
rm -rf /etc/systemd/system/\$service_tbd 2>/dev/null     # and symlinks that might be related
rm -rf /usr/lib/systemd/system/\$service_tbd 2>/dev/null # and symlinks that might be related
rm -rf /etc/init.d/\$service_tbd 2>/dev/null             # and symlinks that might be related
systemctl daemon-reload 2>/dev/null 
systemctl reset-failed 2>/dev/null 
exit 0
EOF

chmod 100 /usr/bin/delete-service

# Deleting un-wanted service
delete-service bluetooth.service
delete-service dbus-org.bluez.service
delete-service nfs-mountd.service
delete-service nfs-server.service
delete-service nfs-statd.service
delete-service systemd-networkd.socket
delete-service syslog.socket
delete-service syslog.service
delete-service klogd.service
delete-service alsa-restore.service
delete-service ofono.service

echo ""

# Restarting
shutdown -r +1 "System will restart in 1 minute, save your work ASAP"
