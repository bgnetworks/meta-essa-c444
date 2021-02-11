FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_bl.sh"

# By default, signing is disabled. Overwrite in local.conf
HAB_SIGN_BL ?= "false"

do_compile() {
    compile_${SOC_FAMILY}

    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin                       ${BOOT_STAGING}

        bbnote "Create a dummy DEK blob"
        dd if=/dev/zero of=${BOOT_STAGING}/dek_blob_fit_dummy.bin bs=96 count=1 conv=fsync
    fi

    # mkimage for i.MX8
    for target in ${IMXBOOT_TARGETS}; do
        bbnote "building ${SOC_TARGET} - ${REV_OPTION} ${target}"
        make SOC=${SOC_TARGET} ${REV_OPTION} ${target}
        if [ -e "${BOOT_STAGING}/flash.bin" ]; then
            cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
        fi
    done
}

do_hab_sign() {
    [ "${HAB_SIGN_BL}" = "true" ] && [ "${CST_DIR}" ] && {
        bbnote "Calling script to sign the flash.bin"
        bbwarn "Script contains hard coded file names/directories, update them before execution."
        ${WORKDIR}/sign_bl.sh -d ${WORKDIR} -c ${CST_DIR}
    } || bbwarn "FIT signing is not performed. Provide CST_DIR = <cst_dir> and set HAB_SIGN_BL = \"true\" in your local.conf"
}

do_deploy_append() {
    [ "${HAB_SIGN_BL}" = "true" ] && [ "${CST_DIR}" ] && {
        bbnote "Installing signed flash as signed_flash.bin  & unsigned flash as unsigned_flash.bin for easy reference"
        bbnote "signed_flash will be used by default"
        install -m 0644 ${WORKDIR}/signed_fit/signed_flash.bin ${DEPLOYDIR}
        install -m 0644 ${WORKDIR}/git/iMX8M/flash.bin ${DEPLOYDIR}/unsigned_flash.bin

        cd ${DEPLOYDIR}
        rm -f ${BOOT_NAME}
        ln -sfv signed_flash.bin ${BOOT_NAME}
        cd -
    } || bbnote "No signing performed, hence unsigned image used."
}

LOG_DIR ?= "${WORKDIR}/temp"
BL_SIGNED ?= "${BOOT_STAGING}/flash.bin"

addtask hab_sign after do_compile before do_deploy
do_hab_sign[vardeps] = "LOG_DIR BL_SIGNED"
