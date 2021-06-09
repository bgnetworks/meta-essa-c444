<!-- 
# File: README.md
# Author: Daniel Selvan, Jasmin Infotech
# Copyright (c) 2021 BG Networks, Inc.
#
# See LICENSE file for license details.
-->

# meta-bgn-essa

[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/embedded-security-software-architecture/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption, authentication, and secure software updates. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

This repository is based on [WinSystems/c444-manifest](https://github.com/WinSystems/c444-manifest/tree/master) (_5.4.24 release_) and enables [Mender](https://mender.io/) OTA and NXP's HAB features on WINSYSTEM's [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/) hardware.

## Supported Boards

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Quick Start Guide for instructions on installing repo.

#### 1. Install the WinSystems Linux BSP & BGN-ESSA repo

```bash
repo init -u https://github.com/WinSystems/c444-manifest.git -b master -m itx-p-c444_5.4.24.xml

# Only works on Public repository
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/bgnetworks/meta-bgn-essa/zeus/meta-mender-c444/scripts/c444_5.4.24-essa-demo.xml
repo init -m c444_5.4.24-essa-demo.xml
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

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-bgn-essa/pulls).

## Maintainer(s)

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)

