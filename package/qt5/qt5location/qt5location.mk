################################################################################
#
# qt5location
#
################################################################################

QT5LOCATION_VERSION = 861e372b6ad81570d4f496e42fb25a6699b72f2f
QT5LOCATION_SITE = $(QT5_SITE)/qtlocation/-/archive/$(QT5LOCATION_VERSION)
QT5LOCATION_SOURCE = qtlocation-$(QT5LOCATION_VERSION).tar.bz2
QT5LOCATION_PATCH_DEPENDENCIES = qt5location-mapboxgl
QT5LOCATION_INSTALL_STAGING = YES
QT5LOCATION_SYNC_QT_HEADERS = YES

QT5LOCATION_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5LOCATION_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5LOCATION_DEPENDENCIES += qt5declarative
endif

define QT5LOCATION_COPY_MAPBOXGL
	rm -rf $(@D)/src/3rdparty/mapbox-gl-native
	cp -a $(QT5LOCATION_MAPBOXGL_DIR) $(@D)/src/3rdparty/mapbox-gl-native
endef
QT5LOCATION_POST_PATCH_HOOKS += QT5LOCATION_COPY_MAPBOXGL

$(eval $(qmake-package))
