# meta-mender-c444

Mender integration for WinSystems boards

The supported and tested board is:

- [WINSYSTEMS® PICO-ITX Single Board Computer with NXP® i.MX8M Processor](https://www.winsystems.com/product/itx-p-c444/)

## Dependencies

This layer depends on WinSys BSP `itx-p-c444_5.4.24` as well as

```
URI: https://github.com/mendersoftware/meta-mender
branch: zeus
revision: HEAD

URI: https://github.com/bgnetworks/meta-mender-c444/tree/zeus/meta-c444-bgn
branch: zeus
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.

```bash
mkdir mender-c444 && cd mender-c444
repo init -u https://github.com/WinSystems/c444-manifest.git \
          -b master \
          -m itx-p-c444_5.4.24.xml

wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/bgnetworks/meta-mender-c444/zeus/meta-mender-c444/scripts/c444_5.4.24_secure-mender-demo.xml

repo init -m c444_5.4.24_secure-mender-demo.xml
repo sync

MACHINE=imx8mq-itx-p-c444 DISTRO=c444-xwayland source c444-setup-mender.sh -b build
bitbake core-image-base
```

## Maintainer

The author(s) and maintainer(s) of this layer are:

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)

Always include the maintainers when suggesting code changes to this layer.
