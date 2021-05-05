<!-- File: README.md
     Author: Daniel Selvan, Jasmin Infotech
-->

# meta-bgn-essa

This repository is based on [WinSystems/c444-manifest](https://github.com/WinSystems/c444-manifest/tree/master) (_5.4.24 release_) and enables [Mender](https://mender.io/) OTA and NXP's HAB features on WINSYSTEM's [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/).

## Supported board

**NOTE**: This is release is not a production release.

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Guide for instructions on installing repo.

1. Install the WinSystems Linux BSP & mender repo

```bash
repo init -u https://github.com/WinSystems/c444-manifest.git -b master -m itx-p-c444_5.4.24.xml

# Only works on Public repository
wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/bgnetworks/meta-bgn-essa/zeus/meta-bgn-essa/scripts/c444_5.4.24_secure-mender-demo.xml
repo init -m c444_5.4.24_secure-mender-demo.xml
```

2. Download the Yocto Project Layers:

```bash
repo sync -j$(nproc)
```

If you encounter errors on repo init or sync, remove the `.repo` directory and try `repo init` again.

3. Run Linux Yocto Project Setup:

```bash
$ MACHINE=imx8mq-itx-p-c444 DISTRO=c444-xwayland source c444-setup-mender.sh -b <build_folder>
```

where

- `<build_folder>` specifies the build folder name

After this your system will be configured to start a Yocto Project build.

## (Optional) Adding name to mender partitions

The following script name partitions in the image as primary & secondary instead of block's UUID.

Run the following command to apply the patch.

```shell
./name-partition.sh
```

## Build image

#### 1. Setup

**a. For first build**

**i. Initialise build with c444-xwayland**

For setting up the build initially,

```bash
MACHINE=imx8mq-itx-p-c444 DISTRO=c444-xwayland source c444-setup-mender.sh -b build
```

**ii. Manual configuration**

Open `conf/local.conf` in your favorite editor and configure it as follows (these configurations are verified for this repo build)

- Delete `EXTRA_IMAGE_FEATURES += "package-management"` line
- Paste your `MENDER_TENANT_TOKEN` on the placeholder  
  **To get your tenant token:**
  - log in to https://hosted.mender.io
  - click your email at the top right and then "My organization"
  - press the "COPY TO CLIPBOARD"
  - assign content of clipboard to MENDER_TENANT_TOKEN

**Optional configurations:**

- To change the boot medium to eMMC (default SD Card), uncomment the following two lines:

```bash
# Boot from eMMC on imx8mq-itx-p-c444
MENDER_STORAGE_DEVICE_imx8mq-itx-p-c444 = "/dev/mmcblk0"
MENDER_UBOOT_STORAGE_DEVICE_imx8mq-itx-p-c444 = "0"
```

- To change the splash image to v2 (default version 1) uncomment `SPLASH_IMG = "v2"`
- To add HAB authentication uncomment and update the following,

```bash

# Uncomment and update the below line to enable bootloader signing (HAB Authentication)
SIGN_BL = "true"
# Update the full path of the CST folder (It should contain the cst along with the certificates)
CST_DIR = "cst_dir_here"
```

- To get CVE report, uncomment `INHERIT += "vigiles"` line
- To assign password to `root` user, delete `EXTRA_IMAGE_FEATURES ?= "debug-tweaks"` and uncomment the following lines:

```bash
# Setting the root password as toor
INHERIT += "extrausers"
EXTRA_USERS_PARAMS = "usermod -p $(openssl passwd toor) root"
```

**b. For subsequent builds**

<details>
<summary>
Click to expand
</summary>

For subsequent builds, (_this will export yocto variables, hence bitbake and other build commands can be recognized_)

```bash
source setup-environment build
```

</details>

#### 2. Build

_NOTE_: This integration is exclusively tested for core-image-base

```bash
bitbake core-image-base
```

**core-image-base**: "A console-only image that fully supports the target device hardware."

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please send the patches as bellow:

- meta-bgn-essa: files and configuration for mender integration with [PICO-ITX Single Board Computer with NXP® I.MX8M Processor](https://www.winsystems.com/product/itx-p-c444/)
  Path: sources/meta-mender-community/meta-bgn-essa  
  GIT: https://github.com/bgnetworks/meta-bgn-essa.git

## Maintainer

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)

Always include the maintainers when suggesting code changes to this layer.

## LIMITATION

`repo sync` won't download from private repositories and hence the above commands can only be executed successfully, if this repo's visibility is **Public**
