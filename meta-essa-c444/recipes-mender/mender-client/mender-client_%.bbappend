FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_configure_prepend() {
    bbwarn "Enable Mender Client signature verification by following instructions in ${BSPDIR}/sources/meta-mender-community/meta-essa-c444/recipes-mender/mender-client/files/artifact-verify-key.pem"
}

# SRC_URI += "file://artifact-verify-key.pem"

MENDER_UPDATE_POLL_INTERVAL_SECONDS = "5"
MENDER_INVENTORY_POLL_INTERVAL_SECONDS = "5"
MENDER_RETRY_POLL_INTERVAL_SECONDS = "5"