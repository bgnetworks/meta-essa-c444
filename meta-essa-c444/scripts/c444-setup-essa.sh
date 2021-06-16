# ESSA Integration Setup Script
#
# Copyright 2019 NXP
# Copyright 2020 Mender Software Inc
# Copyright (c) 2021 BG Networks, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#

. winsys-setup-release.sh $@

echo "" >>conf/bblayers.conf
echo "# Mender integration layers" >>conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-bgn-essa/meta-mender-c444 \"" >>conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-mender/meta-mender-core \"" >>conf/bblayers.conf

cat ../sources/meta-bgn-essa/templates/local.conf.append >>conf/local.conf
cat ../sources/meta-bgn-essa/meta-mender-c444/templates/local.conf.append >>conf/local.conf

# Adding extra layer (meta-essa-c444)
# Unrelated to mender integration
echo "" >>conf/bblayers.conf
echo "# Custom layer to add HAB & DM-Crypt features" >>conf/bblayers.conf
echo "BBLAYERS += \" \${BSPDIR}/sources/meta-bgn-essa/meta-essa-c444 \"" >>conf/bblayers.conf

cat ../sources/meta-bgn-essa/meta-essa-c444/templates/local.conf.append >>conf/local.conf

echo ""
echo "Mender integration complete."
echo ""
