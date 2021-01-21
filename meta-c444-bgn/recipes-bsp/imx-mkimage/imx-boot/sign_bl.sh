#!/bin/bash

# sign_bl.sh
# Created on 21.01.2021
# CHANGELOG:
# - 21.01.2021
#   Added -c option to provide CST folder as a argument
#   Added check for CST dir
#   TEE entries removed (temp - since tee cannot be integrated in c444)
#
# Daniel D, Jamsin Infotech

#####################################################################################################
#                                                                                                   #
#                                   Secured Boot                                                    #
#                                                                                                   #
#####################################################################################################

OP_DIR=signed_fit
ORIG_BOOT_IMG=git/iMX8M/flash.bin
BOOT_IMG=signed_flash.bin

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

logfile=$WORKDIR/temp/log.do_compile

[ -z "$logfile" ] || [ ! -e "$logfile" ] && {
    echo "logfile does not exist, kindly check the path"

    help
}

echo ""
echo "NOTE: Using log file from $logfile for addresses."

echo ""
echo "Running sign_bl.sh..."
echo ""

if [ ! -e $ORIG_BOOT_IMG ]; then
    echo ""
    echo "Copy the "$ORIG_BOOT_IMG" to the folder"

    help
fi

rm -rf $OP_DIR
mkdir $OP_DIR
cd $OP_DIR

echo "#################### Address Block ####################"
csf_off=$(grep -w "csf_off" $logfile)
csf_off=${csf_off##* }

echo $csf_off

sld_csf_off=$(grep "sld_csf_off" $logfile)
sld_csf_off=${sld_csf_off##* }

echo $sld_csf_off

# Trim the last word from string
trim() {
    # Returns the trimmed string (i.e. without last word)
    echo "${@:1:$#-1}"
}

spl_hab_block=$(grep "spl hab block" $logfile)

spl_ln=${spl_hab_block##* }
spl_hab_block=$(trim $spl_hab_block)

spl_of=${spl_hab_block##* }
spl_hab_block=$(trim $spl_hab_block)

spl_st=${spl_hab_block##* }

echo $spl_st $spl_of $spl_ln

sld_hab_block=$(grep "sld hab block" $logfile)

fit_ln=${sld_hab_block##* }
sld_hab_block=$(trim $sld_hab_block)

fit_of=${sld_hab_block##* }
sld_hab_block=$(trim $sld_hab_block)

fit_st=${sld_hab_block##* }

echo $fit_st $fit_of $fit_ln

fit_hab=($(grep '^0x' $logfile))

ubt_st=${fit_hab[0]}
ubt_of=${fit_hab[1]}

ubt_nodtb=${fit_hab[2]}
ubt_dtb=${fit_hab[5]}
# Calculating u-boot size (16-byte aligned)
ubt_ln=$(printf "0x%X" $(($ubt_nodtb + $ubt_dtb)))

echo $ubt_nodtb
echo $ubt_dtb

echo $ubt_st $ubt_of $ubt_ln

atf_st=${fit_hab[6]}
atf_of=${fit_hab[7]}
atf_ln=${fit_hab[8]}

echo $atf_st $atf_of $atf_ln
echo "#######################################################"

read -r -d '' CSF_COMMON_TXT <<EOM
[Header]
    Version = 4.4
    Hash Algorithm = sha256
    Engine = CAAM
    Engine Configuration = 0
    Certificate Format = X509
    Signature Format = CMS

[Install SRK]
    # Index of the key location in the SRK table to be installed
    File = "$CST/crts/SRK_table.bin"
    Source index = 0

[Install CSFK]
    # Key used to authenticate the CSF data
    File = "$CST/crts/CSF1_1_sha256_2048_65537_v3_usr_crt.pem"

[Authenticate CSF]

[Unlock]
    # Leave Job Ring and DECO master ID registers Unlocked
    Engine = CAAM
    Features = MID

[Install Key]
    # Key slot index used to authenticate the key to be installed
    Verification index = 0
    # Target key slot in HAB key store where key will be installed
    Target index = 2
    # Key to install
    File = "$CST/crts/IMG1_1_sha256_2048_65537_v3_usr_crt.pem"
EOM

echo "Creating sign_spl.csf"

cat <<EOT >sign_spl.csf
$CSF_COMMON_TXT

[Authenticate Data]
    # Key slot index used to authenticate the image data
    Verification index = 2
    # Authenticate Start Address, Offset, Length and file
    Blocks = $spl_st $spl_of $spl_ln "$BOOT_IMG"
EOT

echo "Creating sign_fit.csf"
echo ""

cat <<EOT >sign_fit.csf
$CSF_COMMON_TXT

[Authenticate Data]
    # Key slot index used to authenticate the image data
    Verification index = 2
    # Authenticate Start Address, Offset, Length and file
    Blocks = $fit_st $fit_of $fit_ln "$BOOT_IMG", \\
             $ubt_st $ubt_of $ubt_ln "$BOOT_IMG", \\
             $atf_st $atf_of $atf_ln "$BOOT_IMG"
EOT

# Removing old data, if any
rm -f csf_spl.bin csf_fit.bin $BOOT_IMG

cp $WORKDIR/$ORIG_BOOT_IMG $BOOT_IMG

echo "Generating SPL CSF binary..."

# Calling CST with the CSF input file
cst_status=$($CST/linux64/bin/cst -o csf_spl.bin -i sign_spl.csf)
if echo "$cst_status" | grep -qi 'invalid|error|not present'; then
    echo "$cst_status"

    exit 1
fi
echo "$cst_status"

echo ""
echo "Generating FIT CSF binary..."

# Calling CST with the CSF input file
cst_status=$($CST/linux64/bin/cst -o csf_fit.bin -i sign_fit.csf)
if echo "$cst_status" | grep -qi 'invalid|error|not present'; then
    echo "$cst_status"

    exit 1
fi
echo "$cst_status"
echo ""

# Adding SPL csf data to FIT image
dd if=csf_spl.bin of=$BOOT_IMG seek=$(($csf_off)) bs=1 conv=notrunc

# Adding FIT csf data to FIT image
dd if=csf_fit.bin of=$BOOT_IMG seek=$(($sld_csf_off)) bs=1 conv=notrunc

echo ""
echo "Signed bootloader in $OP_DIR/$BOOT_IMG"

exit 0
