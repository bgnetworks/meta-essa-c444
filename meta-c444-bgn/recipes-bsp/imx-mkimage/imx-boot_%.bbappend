FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_bl.sh"

# By default, signing is disabled. Overwrite in local.conf
SIGN_BL ?= "false"

do_hab_sign() {
    if [ "${SIGN_BL}" != "false" ] && [ "${CST_DIR}" != "" ] ; then
        bbnote "Calling script to sign the flash.bin"
        bbwarn "Script contains hard coded file names/directories, update them before execution."
        ${WORKDIR}/sign_bl.sh -d ${WORKDIR} -c ${CST_DIR}
    else
        bbwarn "FIT signing is not performed. Provide CST_DIR = <cst_dir> and set SIGN_BL = \"true\" in your local.conf"
    fi
}

do_deploy_append() {
    if [ "${SIGN_BL}" != "false" ] && [ "${CST_DIR}" != "" ] ; then
        install -m 0644 ${WORKDIR}/signed_fit/signed_flash.bin ${DEPLOYDIR}

        cd ${DEPLOYDIR}
        rm -f ${BOOT_NAME}
        ln -sfv signed_flash.bin ${BOOT_NAME}
        cd -
    fi
}

LOG_DIR ?= "${WORKDIR}/temp"
SIGN_BL ?= "${BOOT_STAGING}/flash.bin"

addtask hab_sign after do_compile before do_deploy
do_hab_sign[vardeps] = "LOG_DIR SIGN_BL"
