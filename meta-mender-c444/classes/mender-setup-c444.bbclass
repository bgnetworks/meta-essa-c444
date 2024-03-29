# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

IMAGE_FSTYPES_remove = "tar.bz2 ext4 sdcard.bz2 wic.bmap wic.bz2 uefiimg.bz2 sdimg.bmap mender.bmap"

# dummy value as the WIC plugin requires an entry but this will not be used
# for anything beside to satisfy the build dependency
IMAGE_BOOT_FILES_append = "u-boot-${MACHINE}.bin"

MENDER_IMAGE_BOOTLOADER_FILE = "imx-boot"

python __anonymous () {
    # For all i.MX 8* families, set MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET
    # to 2 * IMX_BOOT_SEEK
    if 'mx8' in d.getVar('MACHINEOVERRIDES').split(':'):
        imx_boot_seek = int(d.getVar('IMX_BOOT_SEEK'))
        d.setVar('MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET', str(2 * imx_boot_seek))
}

do_image_sdimg[depends] += "imx-boot:do_deploy"

IMAGE_INSTALL_append = " kernel-image kernel-devicetree"
