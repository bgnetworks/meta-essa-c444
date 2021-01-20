
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
