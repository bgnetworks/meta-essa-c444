SUMMARY = "system initial setup script"
LICENSE = "CLOSED"

SRC_URI = "file://sys_setup.sh"

RDEPENDS_${PN} += "bash"

do_install() {
    # Installing the setup script in /usr/bin
    install -d ${D}/data
    install -m 0755 ${WORKDIR}/sys_setup.sh ${D}/data/
}

FILES_${PN} += "/data/sys_setup.sh"
