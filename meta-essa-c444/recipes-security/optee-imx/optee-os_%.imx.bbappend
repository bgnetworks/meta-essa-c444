do_compile () {
    unset LDFLAGS
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"

    bbnote "Adding encryption flag"
    # For OPTEE Debug logs, add: CFG_TEE_CORE_LOG_LEVEL=4
    oe_runmake CFG_NXPCRYPT=y CFG_GEN_DEK_BLOB=y -C ${S} all
}
