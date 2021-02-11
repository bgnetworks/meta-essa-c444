#!/bin/bash

# sign_kern.sh
# Created on 21.01.2020
# CHANGELOG:
# - 22.01.2021
#   Added -c option to provide CST folder as a argument
#   Added check for CST dir
#
#   Daniel Selvan D, Jamsin Infotech

#####################################################################################################
#                                                                                                   #
#                                   Image Signing                                                   #
#                                                                                                   #
#####################################################################################################

ORIG_IMG=Image
KERNEL_IMG=Image_signed
OP_DIR=signed_${ORIG_IMG}

help() {
    echo ""
    echo "Stopping..."

    # Exit script after printing help
    exit 1
}

while getopts ":d:c:" opt; do
    case $opt in
    d) WORKDIR="$OPTARG" ;;

    c) CST="$OPTARG" ;;

    # Print help if any parameter is non-existent
    ?)
        echo "provide working directory with -d & CST directory with -c"
        help
        ;;
    esac
done

if [ ! -d "$CST" ]; then
    echo "CST does not exist on the provided dir. Kindly check the path"
    help
fi

echo "Moving to Yocto work directory"
cd $WORKDIR

echo ""
echo "Running sign_kern.sh..."
echo ""

if [ ! -e $WORKDIR/$ORIG_IMG ]; then
    echo ""
    echo "Copy the "$ORIG_BOOT_IMG" to the folder"

    help
fi

rm -rfv $OP_DIR
mkdir -vp $OP_DIR
cd $OP_DIR

# size specified in the Image header
KERNEL_SIZE=$(hexdump -e '/4 "%X"' -s 12 -n 8 $WORKDIR/$ORIG_IMG)

IVT_SIZE=0x20
# Can be obtained from U-Boot by running => printenv loadaddr
LOAD_ADDRESS=0x40480000

ivt_loc=$(printf '%X' $(($LOAD_ADDRESS + 0x$KERNEL_SIZE)))
echo "Self pointer: $ivt_loc"
csf_loc=$(printf '%X' $((0x$ivt_loc + $IVT_SIZE)))
echo "CSF pointer: $csf_loc"
img_size=$(printf '%X' $((0x$KERNEL_SIZE + $IVT_SIZE)))
echo "image size: $img_size"

echo "Creating IVT generator script"

# The HAB code requires an Image Vector Table (IVT) for determining the image length and the CSF location.
# IVT to be manually created and appended to the end of the padded Image
cat <<EOT >genIVT.pl
#! /usr/bin/perl -w
##############################################
#   Automatically created by sign_${ORIG_IMG}.sh  #
##############################################
use strict;
open(my \$out, '>:raw', 'ivt.bin') or die "Unable to open: \$!";
print \$out pack("V", 0x442000D1); # Signature
print \$out pack("V", $LOAD_ADDRESS); # Load Address (*load_address)
print \$out pack("V", 0x0); # Reserved
print \$out pack("V", 0x0); # DCD pointer
print \$out pack("V", 0x0); # Boot Data	- Commonly 0x0
print \$out pack("V", 0x$ivt_loc); # Self Pointer (*ivt) = ddr_start + ivt_offset
print \$out pack("V", 0x$csf_loc); # CSF Pointer (*csf)
print \$out pack("V", 0x0); # Reserved
close(\$out);
EOT

echo "IVT file:"
cat genIVT.pl

echo ""
echo "Creating csf_$ORIG_IMG.txt"

# NOTE: HAB does not allow to change the SRK once the first image
# is authenticated, so the same SRK key used in the initial image
# must be used when extending the root of trust.
cat <<EOT >csf_$ORIG_IMG.txt
[Header]
    Version = 4.4
    Hash Algorithm = sha256
    Engine Configuration = 0
    Certificate Format = X509
    Signature Format = CMS
    Engine = CAAM

[Install SRK]
    # Index of the key location in the SRK table to be installed
    File = "$CST/crts/SRK_table.bin"
    Source index = 0

[Install CSFK]
    # Key used to authenticate the CSF data
    File = "$CST/crts/CSF1_1_sha256_2048_65537_v3_usr_crt.pem"

[Authenticate CSF]

[Install Key]
    # Key slot index used to authenticate the key to be installed
    Verification index = 0
    # Target key slot in HAB key store where key will be installed
    Target index = 2
    # Key to install
    File = "$CST/crts/IMG1_1_sha256_2048_65537_v3_usr_crt.pem"

[Authenticate Data]
    # Key slot index used to authenticate the image data
    Verification index = 2
    # Authenticate Start Address, Offset, Length and file
    Blocks = $LOAD_ADDRESS 0x00 0x$img_size "${ORIG_IMG}_pad_ivt.bin"
EOT

echo ""
# Removing old data, if any
rm -vf csf_${ORIG_IMG}.bin ivt.bin ${ORIG_IMG}_pad.bin ${ORIG_IMG}_pad_ivt.bin ${ORIG_IMG}_signed

echo "size of original Image:"
ls -lh $WORKDIR/$ORIG_IMG

echo "Extend $ORIG_IMG to 0x$KERNEL_SIZE (size specified in header)..."
objcopy -v -I binary -O binary --pad-to 0x$KERNEL_SIZE --gap-fill=0x00 $WORKDIR/$ORIG_IMG ${ORIG_IMG}_pad.bin
echo "Length of (generated) padded $ORIG_IMG: 0x$(hexdump ${ORIG_IMG}_pad.bin | tail -n 1)"
ls -lh ${ORIG_IMG}_pad.bin
echo ""

echo "generate IVT"
perl genIVT.pl

echo "ivt.bin dump:"
hexdump ivt.bin

echo ""
echo "Appending the ivt.bin file at the end of the padded $ORIG_IMG..."
cat ${ORIG_IMG}_pad.bin ivt.bin >${ORIG_IMG}_pad_ivt.bin
echo "Length of padded $ORIG_IMG with ivt: 0x$(hexdump ${ORIG_IMG}_pad_ivt.bin | tail -n 1)"

echo ""
echo "Calling CST with the CSF input file ..."
csf_status=$($CST/linux64/bin/cst -o csf_${ORIG_IMG}.bin -i csf_${ORIG_IMG}.txt)
if echo "$csf_status" | grep -qi 'invalid\|error'; then
    echo $csf_status

    exit 1
fi
echo $csf_status

echo ""
echo "Attaching the CSF binary to the end of the image..."
cat ${ORIG_IMG}_pad_ivt.bin csf_${ORIG_IMG}.bin >$KERNEL_IMG
mv -v $WORKDIR/$ORIG_IMG $WORKDIR/unsigned_$ORIG_IMG
cp -v $KERNEL_IMG $WORKDIR/$ORIG_IMG
echo "Length of signed $ORIG_IMG: 0x$(hexdump $KERNEL_IMG | tail -n 1)"
echo ""
echo "The provided $ORIG_IMG signed successfully"

exit 0
