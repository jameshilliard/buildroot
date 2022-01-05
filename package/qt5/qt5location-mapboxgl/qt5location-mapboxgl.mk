################################################################################
#
# qt5location-mapboxgl
#
################################################################################

QT5LOCATION_MAPBOXGL_VERSION = d3101bbc22edd41c9036ea487d4a71eabd97823d
QT5LOCATION_MAPBOXGL_SITE = $(QT5_SITE)/qtlocation-mapboxgl/-/archive/$(QT5LOCATION_MAPBOXGL_VERSION)
QT5LOCATION_MAPBOXGL_SOURCE = qtlocation-mapboxgl-$(QT5LOCATION_MAPBOXGL_VERSION).tar.bz2
QT5LOCATION_MAPBOXGL_LICENSE = Apache-2.0, BSD-2-Clause, BSD-3-Clause, BSL-1.0, curl, IJG, ISC, Libpng, MIT, NCSA, OpenSSL, Zlib
QT5LOCATION_MAPBOXGL_LICENSE_FILES = LICENSE.md LICENSE_Boost.txt LICENSE_CSSColorParser.txt LICENSE_geojson.txt LICENSE_geojson_vt_cpp.txt LICENSE_geometry.txt LICENSE_mapbox.txt LICENSE_parsedate.txt LICENSE_protozero.txt LICENSE_rapidjson.txt LICENSE_vectortile.txt LICENSE_wagyu.txt
QT5LOCATION_MAPBOXGL_INSTALL_TARGET = NO

$(eval $(generic-package))
