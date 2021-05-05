# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_configure_prepend() {
    bbwarn "Enable Mender Client signature verification by following instructions in ${BSPDIR}/sources/meta-bgn-essa/meta-essa-c444/recipes-mender/mender-client/files/artifact-verify-key.pem"
}

# SRC_URI += "file://artifact-verify-key.pem"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "5"