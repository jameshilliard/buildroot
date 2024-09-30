################################################################################
#
# libppd
#
################################################################################

LIBPPD_VERSION = 2.0.0
LIBPPD_SOURCE = libppd-$(LIBPPD_VERSION).tar.xz
LIBPPD_SITE = https://github.com/OpenPrinting/libppd/releases/download/$(LIBPPD_VERSION)
LIBPPD_LICENSE = Apache-2.0 with GPL-2.0/LGPL-2.0 exception
LIBPPD_LICENSE_FILES = COPYING LICENSE
LIBPPD_INSTALL_STAGING = YES
LIBPPD_DEPENDENCIES = cups libcupsfilters

LIBPPD_CONF_OPTS = \
	--disable-mutool \
	--with-cups-config=$(STAGING_DIR)/usr/bin/cups-config \
	--with-sysroot=$(STAGING_DIR) \
	--with-pdftops=pdftops

ifeq ($(BR2_PACKAGE_GHOSTSCRIPT),y)
LIBPPD_DEPENDENCIES += ghostscript
LIBPPD_CONF_OPTS += --enable-ghostscript
else
LIBPPD_CONF_OPTS += --disable-ghostscript
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
LIBPPD_DEPENDENCIES += poppler
LIBPPD_CONF_OPTS += --enable-pdftops
else
LIBPPD_CONF_OPTS += --disable-pdftops
endif

$(eval $(autotools-package))
