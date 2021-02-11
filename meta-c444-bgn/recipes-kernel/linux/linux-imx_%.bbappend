FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://sign_kern.sh"

# Dm-crypt fragment for 5.4 kernel
SRC_URI += "file://0001-device-mapper-and-crypt-target.cfg"
SRC_URI += "file://0002-cryptographic-API-functions.cfg"

IMAGE_DIR ?= "${WORKDIR}/build/arch/arm64/boot"
SIGN_IMG ?= "${IMAGE_DIR}/Image"

# By default, signing is disabled. Overwrite in local.conf
HAB_SIGN_KERNEL ?= "false"

do_configure_append() {
    cat ../*.cfg >>${B}/.config
}

do_hab_sign() {
    [ "${HAB_SIGN_KERNEL}" = "true" ] && [ "${CST_DIR}" ] && {
        bbnote "Calling script to sign the kernel Image"
        bbwarn "Script contains hard coded file names/directories, update them before execution."
        ${WORKDIR}/sign_kern.sh -d ${IMAGE_DIR} -c ${CST_DIR}
    } || bbwarn "Image signing is not performed. Provide CST_DIR = <cst_dir> and set HAB_SIGN_KERNEL = \"true\" in your local.conf"
}

do_deploy_append() {
    [ "${HAB_SIGN_KERNEL}" = "true" ] && [ "${CST_DIR}" ] && {
        bbnote "Installing signed Image as signed_Image  & unsigned Image as unsigned_Image for easy reference"
        bbnote "signed_Image will be used by default"
        install -m 0644 ${SIGN_IMG} ${DEPLOYDIR}/signed_Image
        install -m 0644 ${IMAGE_DIR}/unsigned_Image ${DEPLOYDIR}/
    } || bbnote "No signing performed, hence unsigned image used."
}

addtask hab_sign after do_compile before do_install
do_hab_sign[vardeps] = "IMAGE_DIR SIGN_IMG"
