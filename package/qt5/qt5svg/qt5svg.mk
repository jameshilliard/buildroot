################################################################################
#
# qt5svg
#
################################################################################

QT5SVG_VERSION = 24128cdf8bef53eddf31a5709bbbc46293006b1c
QT5SVG_SITE = $(QT5_SITE_BASE)/qtsvg/-/archive/$(QT5SVG_VERSION)
QT5SVG_SOURCE = qtsvg-$(QT5SVG_VERSION).tar.bz2
QT5SVG_INSTALL_STAGING = YES
QT5SVG_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5SVG_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

define QT5SVG_TOUCH_GIT
	touch $(@D)/.git
endef
QT5SVG_POST_EXTRACT_HOOKS += QT5SVG_TOUCH_GIT

$(eval $(qmake-package))
