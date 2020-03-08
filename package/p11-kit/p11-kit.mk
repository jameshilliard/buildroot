################################################################################
#
# p11-kit
#
################################################################################

P11_KIT_VERSION = 0.23.20
P11_KIT_SITE = https://github.com/p11-glue/p11-kit/releases/download/$(P11_KIT_VERSION)
P11_KIT_SOURCE = p11-kit-$(P11_KIT_VERSION).tar.xz
P11_KIT_DEPENDENCIES = host-pkgconf host-libtasn1 libffi libtasn1
P11_KIT_INSTALL_STAGING = YES
P11_KIT_CONF_OPTS = -Dlibffi=enabled -Dtrust_module=enabled -Dsystemd=disabled
P11_KIT_LICENSE = BSD-3-Clause
P11_KIT_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_CA_CERTIFICATES),y)
P11_KIT_CONF_OPTS += -Dtrust_paths=/etc/ssl/certs/ca-certificates.crt
endif

$(eval $(meson-package))
