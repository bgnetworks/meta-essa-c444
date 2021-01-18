FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# HAB features
SRC_URI += "file://0001-Enable-HAB-features.patch"

SRC_URI += "file://0002-Add-fastboot-commands.patch"

