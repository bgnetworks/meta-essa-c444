<!-- 
# File: README.md
# Author: Daniel Selvan, Jasmin Infotech
# Copyright (c) 2021 BG Networks, Inc.
#
# See LICENSE file for license details.
-->

# meta-bgn-essa

[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/embedded-security-software-architecture/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption, authentication, and secure software updates. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

This repository is based on [WinSystems/c444-manifest](https://github.com/bgnetworks/c444-manifest/tree/master) (_5.4.47 release_) and enables [Mender](https://mender.io/) OTA and NXP's HAB features on WINSYSTEM's [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/) hardware.

## Supported Boards

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Quick Start Guide for instructions on installing repo.

#### 1. Install the WinSystems Linux BSP & BGN-ESSA repo

```bash
repo init -u https://github.com/bgnetworks/c444-manifest.git -b master -m itx-p-c444_5.4.47.xml
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/bgnetworks/meta-bgn-essa/zeus-w-caam/meta-mender-c444/scripts/c444_5.4.47-essa-demo.xml
repo init -m c444_5.4.47-essa-demo.xml
```

**NOTE**: _Use_ `c444-setup-essa.sh` _script for initialization._

#### 2. Build

_NOTE_: This integration is exclusively tested for `core-image-base`

```bash
bitbake core-image-base
```

**core-image-base**: "A console-only image that fully supports the target device hardware."

## Detailed Guide

To know more about the BG Networks ESSA and its potential capabilities, [contact BG Networks](https://bgnet.works/contact-us).

## DM-Crypt with CAAM Black keys

Execute the following commands on the `ITX-P-C444` console for a quick demo of **DM-Crypt with CAAM's black key** support

```bash
caam-keygen create randomkey ecb -s 16
cat /data/caam/randomkey | keyctl padd logon logkey: @s
keyctl list @s

dd if=/dev/zero of=encrypted.img bs=1M count=32
losetup /dev/loop0 encrypted.img

dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/loop0) crypt capi:tk(cbc(aes))-plain :36:logon:logkey: 0 /dev/loop0 0 1 sector_size:512"
dmsetup table --showkey encrypted

mkfs.ext4 /dev/mapper/encrypted
mkdir /mnt/encrypted
mount -t ext4 /dev/mapper/encrypted /mnt/encrypted/

echo "This is a test of disk encryption on WINSYSTEMS ITX-P-C444" > /mnt/encrypted/readme.txt
umount /mnt/encrypted/
dmsetup remove encrypted
reboot

caam-keygen import /data/caam/randomkey.bb importKey
cat /data/caam/importKey | keyctl padd logon dmkey @s
rm -f /data/caam/importKey

losetup /dev/loop0 encrypted.img
dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/loop0) crypt capi:tk(cbc(aes))-plain :36:logon:dmkey: 0 /dev/loop0 0 1 sector_size:512"
dmsetup status encrypted

mount /dev/mapper/encrypted /mnt/encrypted/
cat /mnt/encrypted/readme.txt
```

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-bgn-essa/pulls).

## Maintainer(s)

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)
- Glen Anderson - [hellbent](https://github.com/hellbent)

