################################################################################
#
# qt5declarative
#
################################################################################

QT5DECLARATIVE_VERSION = 8aa1164f1bb6a5dfb5527bcfbf128ab6f2c73ed4
QT5DECLARATIVE_SITE = $(QT5_SITE_BASE)/qtdeclarative/-/archive/$(QT5DECLARATIVE_VERSION)
QT5DECLARATIVE_SOURCE = qtdeclarative-$(QT5DECLARATIVE_VERSION).tar.bz2
QT5DECLARATIVE_INSTALL_STAGING = YES

QT5DECLARATIVE_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5DECLARATIVE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL

define QT5DECLARATIVE_TOUCH_GIT
	touch $(@D)/.git
endef
QT5DECLARATIVE_POST_EXTRACT_HOOKS += QT5DECLARATIVE_TOUCH_GIT

$(eval $(qmake-package))
