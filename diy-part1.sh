#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================

SHELL_FOLDER=$(dirname $(readlink -f "$0"))
bash $SHELL_FOLDER/../common/kernel_5.15.sh

# svn co https://github.com/coolsnowwolf/lede/tree/master/target/linux/x86/files target/linux/x86/files
# rm -rf target/linux/x86/files/.svn

# svn co https://github.com/coolsnowwolf/lede/tree/master/target/linux/x86/patches-5.15 target/linux/x86/patches-5.15
# rm -rf target/linux/x86/patches-5.15/.svn

curl -sfL https://raw.githubusercontent.com/coolsnowwolf/lede/master/package/kernel/linux/modules/video.mk -o package/kernel/linux/modules/video.mk
curl -sfL https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/x86/base-files/etc/board.d/02_network -o target/linux/x86/base-files/etc/board.d/02_network

sed -i "s/ +PACKAGE_kmod-backlight:kmod-backlight//" package/kernel/linux/modules/video.mk

sed -i 's/DEFAULT_PACKAGES +=/DEFAULT_PACKAGES += kmod-usb-hid kmod-mmc kmod-sdhci usbutils pciutils lm-sensors-detect kmod-alx kmod-vmxnet3 kmod-igbvf kmod-iavf kmod-bnx2x kmod-pcnet32 kmod-tulip kmod-r8125 kmod-8139cp kmod-8139too kmod-i40e kmod-drm-i915 kmod-drm-amdgpu kmod-mlx4-core kmod-mlx5-core fdisk lsblk kmod-phy-broadcom/' target/linux/x86/Makefile

# mv -f tmp/r81* feeds/kiddin9/
 mv -f https://github.com/kiddin9/openwrt-packages/tree/master/r81* feeds

sed -i 's,kmod-r8169,kmod-r8168,g' target/linux/x86/image/64.mk
sed -i 's/256/1024/g' target/linux/x86/image/Makefile

echo '
CONFIG_ACPI=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_NR_CPUS=512
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_DRM_I915=y
' >> ./target/linux/x86/config-5.15

# Modify default IP 更改IP地址
sed -i 's/192.168.1.1/192.168.0.251/g' package/base-files/files/bin/config_generate

# 把网口0替换为网口1
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
