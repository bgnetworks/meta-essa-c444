# Below patch is not required for the U-Boot version 2019.04 (later than 2018.03)
SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"

# Disable uboot auto configuration
MENDER_UBOOT_AUTO_CONFIGURE = "0"