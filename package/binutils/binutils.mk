################################################################################
#
# binutils
#
################################################################################

# Version is set when using buildroot toolchain.
# If not, we do like other packages
BINUTILS_VERSION = $(call qstrip,$(BR2_BINUTILS_VERSION))
ifeq ($(BINUTILS_VERSION),)
ifeq ($(BR2_arc),y)
BINUTILS_VERSION = arc-2020.09-release
else
BINUTILS_VERSION = 2.37
endif
endif # BINUTILS_VERSION

ifeq ($(BINUTILS_VERSION),arc-2020.09-release)
BINUTILS_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,binutils-gdb,$(BINUTILS_VERSION))
BINUTILS_SOURCE = binutils-gdb-$(BINUTILS_VERSION).tar.gz
BINUTILS_FROM_GIT = y
endif

BINUTILS_SITE ?= $(BR2_GNU_MIRROR)/binutils
BINUTILS_SOURCE ?= binutils-$(BINUTILS_VERSION).tar.xz
BINUTILS_EXTRA_CONFIG_OPTIONS = $(call qstrip,$(BR2_BINUTILS_EXTRA_CONFIG_OPTIONS))
BINUTILS_INSTALL_STAGING = YES
BINUTILS_DEPENDENCIES = zlib $(TARGET_NLS_DEPENDENCIES)
BINUTILS_MAKE_OPTS = LIBS=$(TARGET_NLS_LIBS)
BINUTILS_LICENSE = GPL-3.0+, libiberty LGPL-2.1+
BINUTILS_LICENSE_FILES = COPYING3 COPYING.LIB
BINUTILS_CPE_ID_VENDOR = gnu

ifeq ($(BINUTILS_FROM_GIT),y)
BINUTILS_DEPENDENCIES += host-flex host-bison
HOST_BINUTILS_DEPENDENCIES += host-flex host-bison
endif

# When binutils sources are fetched from the binutils-gdb repository,
# they also contain the gdb sources, but gdb shouldn't be built, so we
# disable it.
BINUTILS_DISABLE_GDB_CONF_OPTS = \
	--disable-sim \
	--disable-gdb

# We need to specify host & target to avoid breaking ARM EABI
BINUTILS_CONF_OPTS = \
	--disable-multilib \
	--disable-werror \
	--host=$(GNU_TARGET_NAME) \
	--target=$(GNU_TARGET_NAME) \
	--enable-install-libiberty \
	--enable-build-warnings=no \
	--with-system-zlib \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

ifeq ($(BR2_STATIC_LIBS),y)
BINUTILS_CONF_OPTS += --disable-plugins
endif

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
BINUTILS_CONF_ENV += MAKEINFO=true
BINUTILS_MAKE_OPTS += MAKEINFO=true
BINUTILS_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MAKEINFO=true install
HOST_BINUTILS_CONF_ENV += MAKEINFO=true
HOST_BINUTILS_MAKE_OPTS += MAKEINFO=true
HOST_BINUTILS_BFP_GAS_MAKE_OPTS += MAKEINFO=true
HOST_BINUTILS_INSTALL_OPTS += MAKEINFO=true install
HOST_BINUTILS_BFP_GAS_INSTALL_OPTS += MAKEINFO=true install

# Workaround a build issue with -Os for ARM Cortex-M cpus.
# (Binutils 2.25.1 and 2.26.1)
# https://sourceware.org/bugzilla/show_bug.cgi?id=20552
ifeq ($(BR2_ARM_CPU_ARMV7M)$(BR2_OPTIMIZE_S),yy)
BINUTILS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -O2"
endif

# "host" binutils should actually be "cross"
# We just keep the convention of "host utility" for now
HOST_BINUTILS_COMMON_CONF_OPTS = \
	--prefix="$(HOST_DIR)" \
	--sysconfdir="$(HOST_DIR)/etc" \
	--localstatedir="$(HOST_DIR)/var" \
	--disable-multilib \
	--disable-werror \
	--disable-shared \
	--enable-static \
	--disable-gtk-doc \
	--disable-gtk-doc-html \
	--disable-doc \
	--disable-docs \
	--disable-documentation \
	--disable-debug \
	--with-xmlto=no \
	--with-fop=no \
	--disable-nls \
	--without-debuginfod \
	--enable-plugins \
	--enable-lto \
	--enable-poison-system-directories \
	$(BINUTILS_DISABLE_GDB_CONF_OPTS) \
	$(BINUTILS_EXTRA_CONFIG_OPTIONS)

HOST_BINUTILS_CONF_OPTS = \
	$(HOST_BINUTILS_COMMON_CONF_OPTS) \
	--target=$(GNU_TARGET_NAME) \
	--with-sysroot=$(STAGING_DIR)
	#--enable-targets=$(GNU_TARGET_NAME),$(BPF_TARGET_NAME)

HOST_BINUTILS_BPF_GAS_CONF_OPTS = \
	$(HOST_BINUTILS_COMMON_CONF_OPTS) \
	--target=$(BPF_TARGET_NAME)

# binutils run configure script of subdirs at make time, so ensure
# our TARGET_CONFIGURE_ARGS are taken into consideration for those
BINUTILS_MAKE_ENV = $(TARGET_CONFIGURE_ARGS)

HOST_BINUTILS_TARGET_BUILDDIR = builddir
HOST_BINUTILS_BPF_GAS_BUILDDIR = builddir-bpf

define HOST_BINUTILS_TARGET_CONFIGURE_SYMLINK
	mkdir -p $(@D)/$(HOST_BINUTILS_TARGET_BUILDDIR)
	ln -sf ../configure $(@D)/$(HOST_BINUTILS_TARGET_BUILDDIR)/configure
endef

define HOST_BINUTILS_BPF_GAS_CONFIGURE_SYMLINK
	mkdir -p $(@D)/$(HOST_BINUTILS_BPF_GAS_BUILDDIR)
	ln -sf ../configure $(@D)/$(HOST_BINUTILS_BPF_GAS_BUILDDIR)/configure
endef

HOST_BINUTILS_PRE_CONFIGURE_HOOKS += HOST_BINUTILS_TARGET_CONFIGURE_SYMLINK
HOST_BINUTILS_PRE_CONFIGURE_HOOKS += HOST_BINUTILS_BPF_GAS_CONFIGURE_SYMLINK

define HOST_BINUTILS_CONFIGURE_CMDS
	(cd $(@D)/$(HOST_BINUTILS_TARGET_BUILDDIR) && rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(HOST_BINUTILS_CONF_ENV) \
		./configure \
		$(QUIET) $(HOST_BINUTILS_CONF_OPTS) \
	)
	(cd $(@D)/$(HOST_BINUTILS_BPF_GAS_BUILDDIR) && rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(HOST_BINUTILS_CONF_ENV) \
		./configure \
		$(QUIET) $(HOST_BINUTILS_BPF_GAS_CONF_OPTS) \
	)
endef

define HOST_BINUTILS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_BINUTILS_MAKE_OPTS) -C $(@D)/$(HOST_BINUTILS_TARGET_BUILDDIR)
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_BINUTILS_BFP_GAS_MAKE_OPTS) -C $(@D)/$(HOST_BINUTILS_BPF_GAS_BUILDDIR)
endef

define HOST_BINUTILS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_BINUTILS_INSTALL_OPTS) -C $(@D)/$(HOST_BINUTILS_TARGET_BUILDDIR)
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_BINUTILS_BFP_GAS_INSTALL_OPTS) -C $(@D)/$(HOST_BINUTILS_BPF_GAS_BUILDDIR)
endef

# We just want libbfd, libiberty and libopcodes,
# not the full-blown binutils in staging
define BINUTILS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(STAGING_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/opcodes DESTDIR=$(STAGING_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/libiberty DESTDIR=$(STAGING_DIR) install
endef

# If we don't want full binutils on target
ifneq ($(BR2_PACKAGE_BINUTILS_TARGET),y)
# libiberty is static-only, so it is only installed to staging, above.
define BINUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/bfd DESTDIR=$(TARGET_DIR) install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/opcodes DESTDIR=$(TARGET_DIR) install
endef
endif

ifneq ($(ARCH_XTENSA_OVERLAY_FILE),)
define BINUTILS_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),binutils)
endef
BINUTILS_POST_EXTRACT_HOOKS += BINUTILS_XTENSA_OVERLAY_EXTRACT
BINUTILS_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
HOST_BINUTILS_POST_EXTRACT_HOOKS += BINUTILS_XTENSA_OVERLAY_EXTRACT
HOST_BINUTILS_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
endif

# Hardlinks between binaries in different directories cause a problem
# with rpath fixup, so we de-hardlink those binaries, and replace them
# with copies instead.
BINUTILS_TOOLS = ar as ld ld.bfd nm objcopy objdump ranlib readelf strip
define HOST_BINUTILS_FIXUP_HARDLINKS
	$(foreach tool,$(BINUTILS_TOOLS),\
		rm -f $(HOST_DIR)/$(GNU_TARGET_NAME)/bin/$(tool) && \
		cp -a $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-$(tool) \
			$(HOST_DIR)/$(GNU_TARGET_NAME)/bin/$(tool)
	)
endef
HOST_BINUTILS_POST_INSTALL_HOOKS += HOST_BINUTILS_FIXUP_HARDLINKS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
