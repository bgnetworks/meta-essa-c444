# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LOGDIR ?= "${WORKDIR}/temp"

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

do_deploy_append() {
    bbnote "Copying compilation log to deploy directory (for signing with BGN-SAT)"
    install -m 0644 ${LOGDIR}/log.do_compile ${DEPLOYDIR}/compile.log
}
