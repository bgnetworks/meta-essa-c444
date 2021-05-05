# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Default splash image
SPLASH_IMG ?= 'v1'

# Splash only supports png images
SRC_URI += "file://${SPLASH_IMG}.png"

SPLASH_IMAGES = "file://${SPLASH_IMG}.png;outsuffix=default"
