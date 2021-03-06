#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

swupd bundle-add sysadmin-basic storage-utils

MAXSIZEMB=$(printf %s\\n 'unit MB print list' | parted | grep "Disk /dev/sda" | cut -d' ' -f3 | tr -d MB)
echo -e "F\n3\nYes\n${MAXSIZEMB}MB\n" | parted /dev/sda ---pretend-input-tty resizepart
partprobe /dev/sda
resize2fs /dev/sda3

swupd bundle-add network-basic editors shells
# timedatectl set-ntp true

systemctl mask tallow

mkdir -p /etc/tmpfiles.d
touch /etc/tmpfiles.d/clr-power-tweaks.conf