# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# HAB features
SRC_URI += "file://0001-Enable-HAB-features.patch"

SRC_URI += "file://0002-Add-fastboot-commands.patch"

# Temp fix
SRC_URI += "file://0003-Pseudo-3GB-for-OPTEE-fix.patch"
