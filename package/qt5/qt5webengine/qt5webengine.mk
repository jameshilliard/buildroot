################################################################################
#
# qt5webengine
#
################################################################################

QT5WEBENGINE_VERSION = 0361b2cce3212ccd9b11cd9c5038edb52f271b53
QT5WEBENGINE_SITE = $(QT5_SITE_BASE)/qtwebengine/-/archive/$(QT5WEBENGINE_VERSION)
QT5WEBENGINE_SOURCE = qtwebengine-$(QT5WEBENGINE_VERSION).tar.bz2
QT5WEBENGINE_DEPENDENCIES = ffmpeg libglib2 libvpx libxkbcommon opus webp \
	qt5declarative qt5webchannel qt5webengine-chromium host-bison host-flex \
	host-gperf host-pkgconf host-python3 host-freetype host-nodejs
QT5WEBENGINE_INSTALL_STAGING = YES

include package/qt5/qt5webengine/chromium-latest.inc

QT5WEBENGINE_LICENSE = GPL-2.0 or LGPL-3.0 or GPL-3.0 or GPL-3.0 with exception
QT5WEBENGINE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT \
	LICENSE.GPLv3 LICENSE.LGPL3 $(QT5WEBENGINE_CHROMIUM_LICENSE_FILES)

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

QT5WEBENGINE_ENV += GN_PKG_CONFIG_HOST=$(HOST_DIR)/bin/pkgconf

QT5WEBENGINE_ENV += GN_HOST_TOOLCHAIN_EXTRA_CPPFLAGS="$(HOST_CPPFLAGS)"

define QT5WEBENGINE_COPY_CHROMIUM
	rm -rf $(@D)/src/3rdparty
	cp -a $(QT5WEBENGINE_CHROMIUM_DIR) $(@D)/src/3rdparty
endef
QT5WEBENGINE_POST_EXTRACT_HOOKS += QT5WEBENGINE_COPY_CHROMIUM

define QT5WEBENGINE_SYNCQT
	(cd $(@D); \
		$(HOST_DIR)/bin/syncqt.pl -version 5.15.8 \
	)
endef
QT5WEBENGINE_POST_EXTRACT_HOOKS += QT5WEBENGINE_SYNCQT

QT5WEBENGINE_CONF_ENV = $(QT5WEBENGINE_ENV)
QT5WEBENGINE_MAKE_ENV = $(QT5WEBENGINE_ENV)

$(eval $(qmake-package))
