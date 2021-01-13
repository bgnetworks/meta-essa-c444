<!-- File: README.md
     Author: Daniel Selvan, Jasmin Infotech
-->

# meta-mender-c444

This repository is based on [WinSystems/c444-manifest](https://github.com/WinSystems/c444-manifest/tree/master) (_5.4.24 release_) and enables [Mender](https://mender.io/) on WINSYSTEM's [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/).

## Supported board

**NOTE**: This is release is not a production release.

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Guide for instructions on installing repo.

1. Install the WinSystems Linux BSP & mender repo

```bash
repo init -u https://github.com/WinSystems/c444-manifest.git -b master -m itx-p-c444_5.4.24.xml

# Can be downloaded from public repositories only
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/danie007/meta-mender-c444/zeus/meta-mender-c444/scripts/c444_5.4.24_secure-mender-demo.xml
repo init -m c444_5.4.24_secure-mender-demo.xml
```

2. Download the Yocto Project Layers:

```bash
repo sync -j$(nproc)
```

If you encounter errors on repo init, remove the `.repo` directory and try `repo init` again.

3. Run Linux Yocto Project Setup:

```bash
$ MACHINE=imx8mq-itx-p-c444 DISTRO=c444-xwayland source c444-setup-mender.sh -b <build_folder>
```

where

- `<build_folder>` specifies the build folder name

After this your system will be configured to start a Yocto Project build.

## (Optional) Adding name to mender partitions

The following script adds name to mender partition. Run the following command to apply the patch.

```shell
./name-partition.sh
```

## Build images

#### Building Wayland

```bash
MACHINE=imx8mq-itx-p-c444 DISTRO=c444-xwayland source c444-setup-mender.sh -b build
bitbake core-image-base
```

**core-image-base**: "A console-only image that fully supports the target device hardware."

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please send the patches as bellow:

- meta-mender-c444: files and configuration for mender integration with [PICO-ITX Single Board Computer with NXP® I.MX8M Processor](https://www.winsystems.com/product/itx-p-c444/)
  Path: sources/meta-mender-community/meta-mender-c444  
  GIT: https://github.com/danie007/meta-mender-c444.git

## Maintainer

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)

Always include the maintainers when suggesting code changes to this layer.

## KNOWN ISSUE

`repo sync` won't work on private repositories and hence the above commands can only be executed successfully, if this repo's visibility changes to **Public**
