################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = $(QT5_VERSION)
QT5WEBENGINE_SITE = $(QT5_SITE)/qtwebengine/-/archive/v$(QT5WEBENGINE_VERSION)-lts
QT5WEBENGINE_SOURCE = qtwebengine-v$(QT5WEBENGINE_VERSION)-lts.tar.bz2
QT5WEBENGINE_DEPENDENCIES = ffmpeg libglib2 libvpx libxkbcommon opus webp \
	qt5declarative qt5webchannel host-bison host-flex host-freetype \
	host-gperf host-nodejs host-pkgconf host-python
QT5WEBENGINE_PATCH_DEPENDENCIES = qt5webengine-chromium
QT5WEBENGINE_INSTALL_STAGING = YES
QT5WEBENGINE_SYNC_QT_HEADERS = YES

QT5WEBENGINE_LICENSE = GPL-2.0 or LGPL-3.0 or GPL-3.0 or GPL-3.0 with exception
QT5WEBENGINE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT \
	LICENSE.GPLv3 LICENSE.LGPL3

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5WEBENGINE_DEPENDENCIES += qt5svg
endif

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBENGINE_DEPENDENCIES += xlib_libXScrnSaver xlib_libXcomposite \
	xlib_libXcursor xlib_libXi xlib_libxkbfile xlib_libXrandr xlib_libXtst
endif

QT5WEBENGINE_DEPENDENCIES += host-libpng host-libnss libnss

QT5WEBENGINE_CONF_OPTS += WEBENGINE_CONFIG+=use_system_ffmpeg

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_PROPRIETARY_CODECS),y)
QT5WEBENGINE_CONF_OPTS += WEBENGINE_CONFIG+=use_proprietary_codecs
endif

ifeq ($(BR2_PACKAGE_QT5WEBENGINE_ALSA),y)
QT5WEBENGINE_DEPENDENCIES += alsa-lib
else
QT5WEBENGINE_CONF_OPTS += QT_CONFIG-=alsa
endif

QT5WEBENGINE_ENV += NINJAFLAGS="-j$(PARALLEL_JOBS)"

define QT5WEBENGINE_COPY_CHROMIUM
	rm -rf $(@D)/src/3rdparty
	cp -a $(QT5WEBENGINE_CHROMIUM_DIR) $(@D)/src/3rdparty
endef
QT5WEBENGINE_POST_PATCH_HOOKS += QT5WEBENGINE_COPY_CHROMIUM

QT5WEBENGINE_ENV += \
	GN_PKG_CONFIG_HOST="$(HOST_DIR)/bin/pkgconf" \
	GN_HOST_TOOLCHAIN_EXTRA_CPPFLAGS="$(HOST_CPPFLAGS) $(HOST_LDFLAGS)"

QT5WEBENGINE_CONF_ENV = $(QT5WEBENGINE_ENV)
QT5WEBENGINE_MAKE_ENV = $(QT5WEBENGINE_ENV)

$(eval $(qmake-package))
