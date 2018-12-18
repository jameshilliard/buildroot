################################################################################
#
# systemd-boot
#
################################################################################

# When updating this version, please also update it in package/systemd/
SYSTEMD_BOOT_VERSION = 243
SYSTEMD_BOOT_SITE = $(call github,systemd,systemd,v$(SYSTEMD_BOOT_VERSION))
SYSTEMD_BOOT_SOURCE = systemd-$(SYSTEMD_BOOT_VERSION).tar.gz
SYSTEMD_BOOT_DL_SUBDIR = systemd

SYSTEMD_BOOT_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README)
SYSTEMD_BOOT_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README

SYSTEMD_BOOT_DEPENDENCIES = gnu-efi

SYSTEMD_BOOT_INSTALL_TARGET = NO
SYSTEMD_BOOT_INSTALL_IMAGES = YES

SYSTEMD_BOOT_CONF_OPTS += \
	-Drootlibdir='/usr/lib' \
	-Dblkid=false \
	-Dman=false \
	-Dima=false \
	-Dlibcryptsetup=false \
	-Defi=true \
	-Dgnu-efi=true \
	-Defi-cc=$(TARGET_CC) \
	-Defi-ld=$(TARGET_LD) \
	-Defi-libdir=$(STAGING_DIR)/usr/lib \
	-Defi-ldsdir=$(STAGING_DIR)/usr/lib \
	-Defi-includedir=$(STAGING_DIR)/usr/include/efi \
	-Dldconfig=false \
	-Ddefault-dnssec=no \
	-Dtests=false \
	-Dnobody-group=nogroup \
	-Didn=false \
	-Dnss-systemd=false \
	-Dacl=false \
	-Daudit=false \
	-Delfutils=false \
	-Dlibidn=false \
	-Dlibidn2=false \
	-Dseccomp=false \
	-Dxkbcommon=false \
	-Dbzip2=false \
	-Dlz4=false \
	-Dpam=false \
	-Dxz=false \
	-Dzlib=false \
	-Dlibcurl=false \
	-Dgcrypt=false \
	-Dpcre2=false \
	-Dmicrohttpd=false \
	-Dqrencode=false \
	-Dselinux=false \
	-Dhwdb=false \
	-Dbinfmt=false \
	-Dvconsole=false \
	-Dquotacheck=false \
	-Dtmpfiles=false \
	-Dsysusers=false \
	-Dfirstboot=false \
	-Drandomseed=false \
	-Dbacklight=false \
	-Drfkill=false \
	-Dlogind=false \
	-Dmachined=false \
	-Dimportd=false \
	-Dhostnamed=false \
	-Dmyhostname=false \
	-Dtimedated=false \
	-Dlocaled=false \
	-Dcoredump=false \
	-Dpolkit=false \
	-Dnetworkd=false \
	-Dresolve=false \
	-Dtimesyncd=false \
	-Dsmack=false \
	-Dhibernate=false

SYSTEMD_BOOT_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_BOOT_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

SYSTEMD_BOOT_TARGET_EFI_ARCH = $(call qstrip,$(BR2_TARGET_SYSTEMD_BOOT_EFI_ARCH))
SYSTEMD_BOOT_NINJA_OPTS = \
	src/boot/efi/systemd-boot$(SYSTEMD_BOOT_TARGET_EFI_ARCH).efi \
	src/boot/efi/linux$(SYSTEMD_BOOT_TARGET_EFI_ARCH).efi.stub

define SYSTEMD_BOOT_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/build/src/boot/efi/systemd-boot$(SYSTEMD_BOOT_TARGET_EFI_ARCH).efi \
		$(BINARIES_DIR)/efi-part/EFI/BOOT/boot$(SYSTEMD_BOOT_TARGET_EFI_ARCH).efi
	echo "boot$(SYSTEMD_BOOT_TARGET_EFI_ARCH).efi" > \
		$(BINARIES_DIR)/efi-part/startup.nsh
	$(INSTALL) -D -m 0644 $(SYSTEMD_BOOT_PKGDIR)/boot-files/loader.conf \
		$(BINARIES_DIR)/efi-part/loader/loader.conf
	$(INSTALL) -D -m 0644 $(SYSTEMD_BOOT_PKGDIR)/boot-files/buildroot.conf \
		$(BINARIES_DIR)/efi-part/loader/entries/buildroot.conf
endef

$(eval $(meson-package))
