################################################################################
#
# tor
#
################################################################################

TOR_VERSION = 0.4.8.17
TOR_SITE = https://dist.torproject.org
TOR_LICENSE = BSD-3-Clause
TOR_LICENSE_FILES = LICENSE
TOR_CPE_ID_VENDOR = torproject
TOR_SELINUX_MODULES = tor
TOR_DEPENDENCIES = libevent openssl zlib

TOR_CONF_OPTS = \
	--disable-gcc-hardening \
	--disable-unittests \
	--with-libevent-dir=$(STAGING_DIR)/usr \
	--with-openssl-dir=$(STAGING_DIR)/usr \
	--with-zlib-dir=$(STAGING_DIR)/usr

ifeq ($(BR2_STATIC_LIBS),y)
TOR_CONF_OPTS += \
	--enable-static-libevent \
	--enable-static-openssl \
	--enable-static-tor \
	--enable-static-zlib
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
TOR_DEPENDENCIES += libcap
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
TOR_CONF_OPTS += --enable-systemd
TOR_DEPENDENCIES += host-pkgconf systemd
else
TOR_CONF_OPTS += --disable-systemd
endif

ifeq ($(BR2_PACKAGE_XZ),y)
TOR_CONF_OPTS += --enable-lzma
TOR_DEPENDENCIES += host-pkgconf xz
else
TOR_CONF_OPTS += --disable-lzma
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
TOR_CONF_OPTS += --enable-zstd
TOR_DEPENDENCIES += host-pkgconf zstd
else
TOR_CONF_OPTS += --disable-zstd
endif

ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_i386)$(BR2_x86_64)$(BR2_PACKAGE_LIBSECCOMP),yy)
TOR_CONF_OPTS += --enable-seccomp
TOR_DEPENDENCIES += libseccomp
else
TOR_CONF_OPTS += --disable-seccomp
endif

# uses gnu extensions
TOR_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
TOR_LIBS += -latomic
endif
ifeq ($(BR2_STATIC_LIBS),y)
TOR_LIBS += -lz
endif
TOR_CONF_ENV += LIBS="$(TOR_LIBS)"

define TOR_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/src/config/torrc.minimal \
		$(TARGET_DIR)/etc/tor/torrc
endef

TOR_POST_INSTALL_TARGET_HOOKS += TOR_INSTALL_CONF

$(eval $(autotools-package))
