# FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# # Dm-crypt fragment for 5.4 kernel
# SRC_URI += "file://0001-cryptographic-API-functions.cfg"
# SRC_URI += "file://0002-device-mapper-and-crypt-target.cfg"

# do_configure_append() {
#     cat ../*.cfg >>${B}/.config
# }

# # Testing needed