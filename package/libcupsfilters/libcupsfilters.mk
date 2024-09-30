################################################################################
#
# libcupsfilters
#
################################################################################

LIBCUPSFILTERS_VERSION = 2.0.0
LIBCUPSFILTERS_SOURCE = libcupsfilters-$(LIBCUPSFILTERS_VERSION).tar.xz
LIBCUPSFILTERS_SITE = https://github.com/OpenPrinting/libcupsfilters/releases/download/$(LIBCUPSFILTERS_VERSION)
LIBCUPSFILTERS_LICENSE = Apache-2.0 with GPL-2.0/LGPL-2.0 exception
LIBCUPSFILTERS_LICENSE_FILES = COPYING LICENSE
LIBCUPSFILTERS_INSTALL_STAGING = YES
LIBCUPSFILTERS_DEPENDENCIES = cups lcms2 qpdf fontconfig jpeg

LIBCUPSFILTERS_CONF_OPTS = \
	--disable-mutool \
	--enable-imagefilters \
	--with-cups-config=$(STAGING_DIR)/usr/bin/cups-config \
	--with-sysroot=$(STAGING_DIR) \
	--with-jpeg \
	--with-test-font-path=/dev/null

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBCUPSFILTERS_CONF_OPTS += --with-png
LIBCUPSFILTERS_DEPENDENCIES += libpng
else
LIBCUPSFILTERS_CONF_OPTS += --without-png
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBCUPSFILTERS_CONF_OPTS += --with-tiff
LIBCUPSFILTERS_DEPENDENCIES += tiff
else
LIBCUPSFILTERS_CONF_OPTS += --without-tiff
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
LIBCUPSFILTERS_CONF_OPTS += --enable-dbus
LIBCUPSFILTERS_DEPENDENCIES += dbus
else
LIBCUPSFILTERS_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_GHOSTSCRIPT),y)
LIBCUPSFILTERS_DEPENDENCIES += ghostscript
LIBCUPSFILTERS_CONF_OPTS += --enable-ghostscript
else
LIBCUPSFILTERS_CONF_OPTS += --disable-ghostscript
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
LIBCUPSFILTERS_DEPENDENCIES += poppler
LIBCUPSFILTERS_CONF_OPTS += --enable-poppler
else
LIBCUPSFILTERS_CONF_OPTS += --disable-poppler
endif

ifeq ($(BR2_PACKAGE_LIBEXIF),y)
LIBCUPSFILTERS_CONF_OPTS += --enable-exif
LIBCUPSFILTERS_DEPENDENCIES += libexif
else
LIBCUPSFILTERS_CONF_OPTS += --disable-exif
endif

$(eval $(autotools-package))
