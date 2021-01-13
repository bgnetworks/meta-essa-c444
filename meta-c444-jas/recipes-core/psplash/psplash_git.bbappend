FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Default splash image
SPLASH_IMG ?= 'v1'

# Splash only supports png images
SRC_URI += "file://${SPLASH_IMG}.png"

SPLASH_IMAGES = "file://${SPLASH_IMG}.png;outsuffix=default"
