# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://systemd-networkd-wait-online.service \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/system/systemd-networkd-wait-online.service \
"

do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system
    install -m 0752 ${WORKDIR}/systemd-networkd-wait-online.service ${D}${sysconfdir}/systemd/system
}
