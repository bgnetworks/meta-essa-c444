<!-- File: README.md
     Author: Daniel Selvan, Jasmin Infotech
-->

# meta-essa-c444

The Embedded Security Software Architecture is a collection of cryptography related scripts, Yocto recipes and configurations for U-boot and the Linux kernel.

## Overview

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
