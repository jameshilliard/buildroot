################################################################################
#
# netbird
#
################################################################################

NETBIRD_VERSION = 0.30.3
NETBIRD_SITE = $(call github,netbirdio,netbird,v$(NETBIRD_VERSION))
NETBIRD_LICENSE = BSD-3-Clause
NETBIRD_LICENSE_FILES = LICENSE
NETBIRD_GOMOD = github.com/netbirdio/netbird
NETBIRD_BUILD_TARGETS = client
NETBIRD_LDFLAGS = \
	-X github.com/netbirdio/netbird/version.version=$(NETBIRD_VERSION)

define NETBIRD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/client $(TARGET_DIR)/usr/bin/netbird
endef

define NETBIRD_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_TUN)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WIREGUARD)
endef

$(eval $(golang-package))
