
#!/bin/bash
#
# Script to apply patch to mender source that add names to partitions on .sdimg
# Added check to determine if the patch was already applied
#
# Author: Daniel Selvan D
# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

CWD=$(pwd)

echo "Patching mender-part-images.bbclass"

# Applying BSP Patch
cd $CWD/sources/meta-mender/meta-mender-core/classes

if ! grep -q "label primary" mender-part-images.bbclass; then
    git apply $CWD/sources/meta-bgn-essa/meta-essa-c444/patches/named-mender-partition.patch
    echo "Successfully added names to Mender partitions in sdimg"
else
    echo "Patch already applied, no need to apply again!"
fi

cd $CWD

exit 0
