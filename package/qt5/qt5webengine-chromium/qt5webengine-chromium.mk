################################################################################
#
# qt5webengine-chromium
#
################################################################################

QT5WEBENGINE_CHROMIUM_VERSION = 0ad2814370799a2161057d92231fe3ee00e2fe98
QT5WEBENGINE_CHROMIUM_SITE = $(QT5_SITE_BASE)/qtwebengine-chromium/-/archive/$(QT5WEBENGINE_CHROMIUM_VERSION)
QT5WEBENGINE_CHROMIUM_SOURCE = qtwebengine-chromium-$(QT5WEBENGINE_CHROMIUM_VERSION).tar.bz2
QT5WEBENGINE_CHROMIUM_DEPENDENCIES = qt5webengine-chromium-catapult

define QT5WEBENGINE_CHROMIUM_COPY_CATAPULT
	rm -rf $(@D)/chromium/third_party/catapult
	cp -a $(QT5WEBENGINE_CHROMIUM_CATAPULT_DIR) $(@D)/chromium/third_party/catapult
endef
QT5WEBENGINE_CHROMIUM_POST_EXTRACT_HOOKS += QT5WEBENGINE_CHROMIUM_COPY_CATAPULT

$(eval $(generic-package))
