FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# Dm-crypt fragment for 5.4 kernel
SRC_URI += "file://0001-device-mapper-and-crypt-target.cfg"
SRC_URI += "file://0002-cryptographic-API-functions.cfg"

# do_configure_prepend() {
#     cat ${B}/.config >~/Desktop/kernel.conf
# }

do_configure_append() {
    cat ../*.cfg >>${B}/.config
    # cat ${B}/.config >~/Desktop/kernel_new.conf
}

# Testing