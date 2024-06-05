################################################################################
#
# flashrom
#
################################################################################

FLASHROM_VERSION = 1.3.0
FLASHROM_SOURCE = flashrom-v$(FLASHROM_VERSION).tar.bz2
FLASHROM_SITE = https://download.flashrom.org/releases
FLASHROM_LICENSE = GPL-2.0+
FLASHROM_LICENSE_FILES = COPYING
FLASHROM_INSTALL_STAGING = YES
FLASHROM_CONF_OPTS = \
	-Dclassic_cli=enabled \
	-Dclassic_cli_print_wiki=disabled \
	-Dich_descriptors_tool=enabled \
	-Dtests=disabled \
	-Duse_internal_dmi=true

FLASHROM_PROGRAMMERS = \
	buspirate_spi \
	linux_mtd \
	linux_spi \
	parade_lspcon \
	mediatek_i2c_spi \
	mstarddc_spi \
	pony_spi \
	rayer_spi \
	realtek_mst_i2c_spi \
	serprog

ifeq ($(BR2_PACKAGE_LIBFTDI1),y)
FLASHROM_DEPENDENCIES += host-pkgconf libftdi1
FLASHROM_PROGRAMMERS += \
	ft2232_spi \
	usbblaster_spi
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
FLASHROM_DEPENDENCIES += host-pkgconf libusb
FLASHROM_PROGRAMMERS += \
	ch341a_spi \
	dediprog \
	developerbox_spi \
	digilent_spi \
	dirtyjtag_spi \
	pickit2_spi \
	raiden_debug_spi \
	stlinkv3_spi
endif

ifeq ($(BR2_PACKAGE_PCIUTILS),y)
FLASHROM_DEPENDENCIES += pciutils
FLASHROM_PROGRAMMERS += \
	atahpt \
	atapromise \
	atavia \
	drkaiser \
	gfxnvidia \
	internal \
	it8212 \
	nic3com \
	nicintel \
	nicintel_eeprom \
	nicintel_spi \
	nicnatsemi \
	nicrealtek \
	ogp_spi \
	satamv \
	satasii
endif

FLASHROM_CONF_OPTS += -Dprogrammer=$(subst $(space),$(comma),$(strip $(FLASHROM_PROGRAMMERS)))

$(eval $(meson-package))
