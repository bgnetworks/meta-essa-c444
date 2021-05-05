<!-- File: README.md
     Author: Daniel Selvan, Jasmin Infotech
# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
-->

# meta-bgn-essa

[BG Network](https://bgnet.works/)’s Embedded Security Software Architecture (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption, authentication, and secure software updates. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

This repository is based on [WinSystems/c444-manifest](https://github.com/WinSystems/c444-manifest/tree/master) (_5.4.24 release_) and enables [Mender](https://mender.io/) OTA and NXP's HAB features on WINSYSTEM's [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/).

## Supported board

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Guide for instructions on installing repo.

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

To know more about the BG Networks ESSA and its potential capabilities, contact BG Networks. (link to be included)

## Contributing

> If community changes are not required, we can mention that in here and remove the maintainer section.

To contribute to the development of this BSP and/or submit patches for new boards please send the patches as bellow:

- meta-bgn-essa: files and configuration for mender integration with [PICO-ITX Single Board Computer with NXP® I.MX8M Processor](https://www.winsystems.com/product/itx-p-c444/)
  Path: sources/meta-bgn-essa/meta-mender-c444
  GIT: https://github.com/bgnetworks/meta-bgn-essa.git

## Maintainer

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)

Always include the maintainers when suggesting code changes to this layer.
