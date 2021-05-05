# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

do_compile () {
    unset LDFLAGS
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"

    bbnote "Adding encryption flag"
    # For OPTEE Debug logs, add: CFG_TEE_CORE_LOG_LEVEL=4
    oe_runmake CFG_NXPCRYPT=y CFG_GEN_DEK_BLOB=y -C ${S} all
}
