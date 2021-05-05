# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

# Below patch is not required for the U-Boot versions later than 2018.03
SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"

# Disable uboot auto configuration
MENDER_UBOOT_AUTO_CONFIGURE = "0"