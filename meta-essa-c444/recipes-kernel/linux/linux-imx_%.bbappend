# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Dm-crypt fragment for 5.4.47 kernel
SRC_URI += "file://0001-device-mapper-and-crypt-target.cfg"
SRC_URI += "file://0002-caam-black-key-driver.cfg"
SRC_URI += "file://0003-cryptographic-API-functions.cfg"

do_configure_append() {
    cat ../*.cfg >>${B}/.config
}
