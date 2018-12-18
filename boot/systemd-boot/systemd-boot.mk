################################################################################
#
# systemd-boot
#
################################################################################

SYSTEMD_BOOT_VERSION = 239
SYSTEMD_BOOT_SITE = $(call github,systemd,systemd,v$(SYSTEMD_BOOT_VERSION))
SYSTEMD_BOOT_DL_SUBDIR = systemd
SYSTEMD_BOOT_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README)
SYSTEMD_BOOT_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README
SYSTEMD_BOOT_INSTALL_STAGING = NO
SYSTEMD_BOOT_INSTALL_TARGET = NO
SYSTEMD_BOOT_INSTALL_IMAGES = YES
SYSTEMD_BOOT_DEPENDENCIES = \
	gnu-efi \
	util-linux
ifeq ($(BR2_PACKAGE_SYSTEMD_BOOT),y)
SYSTEMD_BOOT_DEPENDENCIES += systemd
endif

ifeq ($(BR2_i386),y)
SYSTEMD_BOOT_IMGARCH = ia32
else ifeq ($(BR2_x86_64),y)
SYSTEMD_BOOT_IMGARCH = x64
endif

ifneq ($(BR2_PACKAGE_SYSTEMD_BOOT),y)
SYSTEMD_BOOT_CONF_OPTS += \
	-Drootlibdir='/usr/lib' \
	-Dblkid=true \
	-Dman=false \
	-Dima=false \
	-Dlibcryptsetup=false \
	-Defi=true \
	-Defi-cc=$(TARGET_CC) \
	-Defi-ld=$(TARGET_LD) \
	-Defi-libdir=$(STAGING_DIR)/usr/lib \
	-Defi-ldsdir=$(STAGING_DIR)/usr/lib \
	-Defi-includedir=$(STAGING_DIR)/usr/include/efi \
	-Dgnu-efi=true \
	-Dldconfig=false \
	-Ddefault-dnssec=no \
	-Dtests=false \
	-Dnobody-group=nogroup \
	-Didn=true \
	-Dnss-systemd=true \
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
endif

SYSTEMD_BOOT_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_BOOT_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

ifeq ($(BR2_PACKAGE_SYSTEMD_BOOT),y)
define SYSTEMD_BOOT_BUILD_CMDS
	mkdir -p $(@D)/build/src/boot/efi
	cp $(TARGET_DIR)/usr/lib/systemd/boot/efi/systemd-boot$(SYSTEMD_BOOT_IMGARCH).efi \
		$(@D)/build/src/boot/efi/systemd-boot$(SYSTEMD_BOOT_IMGARCH).efi
	cp $(TARGET_DIR)/usr/lib/systemd/boot/efi/linux$(SYSTEMD_BOOT_IMGARCH).efi.stub \
		$(@D)/build/src/boot/efi/linux$(SYSTEMD_BOOT_IMGARCH).efi.stub
endef
else
define SYSTEMD_BOOT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(SYSTEMD_BOOT_NINJA_ENV) \
		$(NINJA) $(NINJA_OPTS) -C $(@D)/build \
		src/boot/efi/{systemd-boot$(SYSTEMD_BOOT_IMGARCH).efi,linux$(SYSTEMD_BOOT_IMGARCH).efi.stub}
endef
endif

define SYSTEMD_BOOT_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/build/src/boot/efi/systemd-boot$(SYSTEMD_BOOT_IMGARCH).efi \
		$(BINARIES_DIR)/efi-part/EFI/BOOT/boot$(SYSTEMD_BOOT_IMGARCH).efi
	echo "boot$(SYSTEMD_BOOT_IMGARCH).efi" > \
		$(BINARIES_DIR)/efi-part/startup.nsh
	$(INSTALL) -D -m 0644 $(SYSTEMD_BOOT_PKGDIR)/loader.conf \
		$(BINARIES_DIR)/efi-part/loader/loader.conf
	$(INSTALL) -D -m 0644 $(SYSTEMD_BOOT_PKGDIR)/buildroot.conf \
		$(BINARIES_DIR)/efi-part/loader/entries/buildroot.conf
endef

ifeq ($(BR2_PACKAGE_SYSTEMD_BOOT),y)
$(eval $(generic-package))
else
$(eval $(meson-package))
endif
