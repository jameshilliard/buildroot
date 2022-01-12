################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = $(QT5_VERSION)
QT5WEBENGINE_SITE = $(QT5_SITE)
QT5WEBENGINE_SOURCE = qtwebengine-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5WEBENGINE_VERSION).tar.xz
QT5WEBENGINE_DEPENDENCIES = qt5declarative qt5webchannel host-bison host-flex \
	host-gperf host-icu host-ninja host-pkgconf host-python host-webp host-zlib
QT5WEBENGINE_INSTALL_STAGING = YES

include package/qt5/qt5webengine/chromium-latest.inc

QT5WEBENGINE_LICENSE = GPL-2.0 or LGPL-3.0 or GPL-3.0 or GPL-3.0 with exception
QT5WEBENGINE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT \
	LICENSE.GPLv3 LICENSE.LGPL3 $(QT5WEBENGINE_CHROMIUM_LICENSE_FILES)

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5WEBENGINE_DEPENDENCIES += qt5svg
endif

QT5WEBENGINE_DEPENDENCIES += host-libpng host-libnss

ifeq ($(BR2_PACKAGE_QT5BASE_FONTCONFIG),y)
QT5WEBENGINE_DEPENDENCIES += host-freetype
endif

ifeq ($(BR2_PACKAGE_QT5BASE_JPEG),y)
QT5WEBENGINE_DEPENDENCIES += host-libjpeg
endif

QT5WEBENGINE_CONF_OPTS += \
	-feature-webengine-system-ffmpeg \
	-feature-webengine-system-glib \
	-feature-webengine-system-harfbuzz \
	-feature-webengine-system-libevent \
	-feature-webengine-system-libvpx \
	-feature-webengine-system-libwebp \
	-feature-webengine-system-libxml2 \
	-feature-webengine-system-ninja \
	-feature-webengine-system-opus \
	-feature-webengine-system-png \
	-feature-webengine-system-zlib

QT5WEBENGINE_CONF_OPTS += \
	-no-feature-webengine-system-icu \
	-no-feature-webengine-system-minizip \
	-no-feature-webengine-system-gn \
	-no-feature-webengine-v8-snapshot-support

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_PROPRIETARY_CODECS),y)
QT5WEBENGINE_CONF_OPTS += -feature-webengine-proprietary-codecs
else
QT5WEBENGINE_CONF_OPTS += -no-feature-webengine-proprietary-codecs
endif

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_ALSA),y)
QT5WEBENGINE_DEPENDENCIES += alsa-lib
QT5WEBENGINE_CONF_OPTS += -feature-webengine-alsa
else
QT5WEBENGINE_CONF_OPTS += -no-feature-webengine-alsa
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
QT5WEBENGINE_DEPENDENCIES += pulseaudio
QT5WEBENGINE_CONF_OPTS += -feature-webengine-pulseaudio
else
QT5WEBENGINE_CONF_OPTS += -no-feature-webengine-pulseaudio
endif

# QtWebengine's build system uses python, but only supports python2. We work
# around this by forcing python2 early in the PATH, via a python->python2
# symlink.
QT5WEBENGINE_ENV = \
	PATH=$(@D)/host-bin:$(BR_PATH) \
	PKG_CONFIG_SYSROOT_DIR="/"
define QT5WEBENGINE_PYTHON2_SYMLINK
	mkdir -p $(@D)/host-bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/host-bin/python
endef
QT5WEBENGINE_PRE_CONFIGURE_HOOKS += QT5WEBENGINE_PYTHON2_SYMLINK

QT5WEBENGINE_ENV += NINJAFLAGS="-j$(PARALLEL_JOBS)"

define QT5WEBENGINE_CREATE_HOST_PKG_CONFIG
	sed s%@HOST_DIR@%$(HOST_DIR)%g $(QT5WEBENGINE_PKGDIR)/host-pkg-config.in > $(@D)/host-bin/host-pkg-config
	chmod +x $(@D)/host-bin/host-pkg-config
endef
QT5WEBENGINE_PRE_CONFIGURE_HOOKS += QT5WEBENGINE_CREATE_HOST_PKG_CONFIG
QT5WEBENGINE_ENV += \
	GN_PKG_CONFIG_HOST=$(@D)/host-bin/host-pkg-config \
	GN_HOST_TOOLCHAIN_EXTRA_CPPFLAGS="$(HOST_CPPFLAGS)"

QT5WEBENGINE_CONF_ENV = $(QT5WEBENGINE_ENV)
QT5WEBENGINE_MAKE_ENV = $(QT5WEBENGINE_ENV)

$(eval $(qmake-package))
