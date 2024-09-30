################################################################################
#
# cups-filters
#
################################################################################

CUPS_FILTERS_VERSION = 2.0.1
CUPS_FILTERS_SOURCE = cups-filters-$(CUPS_FILTERS_VERSION).tar.xz
CUPS_FILTERS_SITE = https://github.com/OpenPrinting/cups-filters/releases/download/$(CUPS_FILTERS_VERSION)
CUPS_FILTERS_LICENSE = Apache-2.0 with GPL-2.0/LGPL-2.0 exception
CUPS_FILTERS_LICENSE_FILES = COPYING LICENSE
CUPS_FILTERS_CPE_ID_VENDOR = linuxfoundation

CUPS_FILTERS_DEPENDENCIES = cups libcupsfilters libppd

CUPS_FILTERS_CONF_OPTS = \
	--disable-mutool \
	--disable-foomatic \
	--enable-pstops \
	--enable-rastertopwg \
	--enable-imagefilters \
	--with-shell=/bin/sh \
	--with-cups-config=$(STAGING_DIR)/usr/bin/cups-config \
	--with-sysroot=$(STAGING_DIR)

ifeq ($(BR2_PACKAGE_GHOSTSCRIPT),y)
CUPS_FILTERS_DEPENDENCIES += ghostscript
CUPS_FILTERS_CONF_OPTS += --enable-ghostscript
else
CUPS_FILTERS_CONF_OPTS += --disable-ghostscript
endif

ifeq ($(BR2_PACKAGE_POPPLER),y)
CUPS_FILTERS_DEPENDENCIES += poppler
CUPS_FILTERS_CONF_OPTS += --enable-poppler
else
CUPS_FILTERS_CONF_OPTS += --disable-poppler
endif

$(eval $(autotools-package))
