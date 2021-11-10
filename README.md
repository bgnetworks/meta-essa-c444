<!-- 
# File: README.md
# Copyright (c) 2021 BG Networks, Inc.
# See LICENSE file for license details.
-->

# meta-bgn-essa

[BG Network's](https://bgnet.works/) [Embedded Security Software Architecture](https://bgnet.works/embedded-security-software-architecture/) (ESSA), a collection of scripts, recipes, configurations, and documentation for Linux, enhances cybersecurity for IoT devices, including secure boot, encryption, authentication, and secure software updates. The ESSA enables engineers to extend a hardware root of trust to secure U-Boot, the Linux kernel, and applications in the root file system.

To provide strong cybersecurity without compromising performance or functionality, this architecture leverage:

- In-silicon cryptographic accelerators and secure memory
- Over-The-Air (OTA) software update solution from open-source and trusted partners
- Linux security features

The ESSA is Linux based and when used in conjunction with the SAT will support:

- Hardware root of trust extended to the rootfs and software application layer Configuration of Linux Device Mapper (DM) cryptographic functions.
- Use of AES-XTS and HMAC-SHA256 cryptographic algorithms.
- OTA software update support based on Mender.<d/>io
- Root of trust extended to Mender.<d/>io client software

Mender.<d/>io security features include:

- Client-server authentication using RSA signatures and JWTs
- Software updates sent over an encrypted channel (HTTPS)
- Software updates authenticated using RSA signatures

## Supported Boards

The following board is the only board tested in this release.

- WINSYSTEM ITX-P-C444 (imx8mq-itx-p-c444) - [ITX-P-C444](https://www.winsystems.com/product/itx-p-c444/)

## Quick Start Guide

See the Quick Start Guide for instructions of building core image and for a quick demo of **DM-Crypt with CAAM's black key**.

## Detailed Guide

To know more about the BG Networks ESSA and its potential capabilities, [contact BG Networks](https://bgnet.works/contact-us).

## Contributing

To contribute to the development of this BSP and/or submit patches for new boards please feel free to [create pull requests](https://github.com/bgnetworks/meta-bgn-essa/pulls).

## Maintainer(s)

The author(s) and maintainer(s) of this layer is(are):

- Daniel Selvan D - <daniel.selvan@jasmin-infotech.com> - [danie007](https://github.com/danie007)
- Glen Anderson - [hellbent](https://github.com/hellbent)

