################################################################################
#
# gcc-bpf
#
################################################################################

GCC_BPF_VERSION = $(GCC_VERSION)
GCC_BPF_SITE = $(GCC_SITE)
GCC_BPF_SOURCE = $(GCC_SOURCE)

HOST_GCC_BPF_DL_SUBDIR = gcc

HOST_GCC_BPF_DEPENDENCIES = \
	$(HOST_GCC_COMMON_DEPENDENCIES) \
	$(BR_LIBC)

HOST_GCC_BPF_EXCLUDES = $(HOST_GCC_EXCLUDES)

HOST_GCC_BPF_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_BPF_SUBDIR = build

HOST_GCC_BPF_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

HOST_GCC_BPF_CONF_OPTS = \
	--target=$(BPF_TARGET_NAME) \
	--prefix="$(HOST_DIR)" \
	--sysconfdir="$(HOST_DIR)/etc" \
	--enable-languages=c \
	--with-gnu-ld \
	--enable-static \
	--disable-decimal-float \
	--disable-gcov \
	--disable-libssp \
	--disable-multilib \
	--disable-shared \
	--with-gmp=$(HOST_DIR) \
	--with-mpc=$(HOST_DIR) \
	--with-mpfr=$(HOST_DIR) \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/" \
	--without-zstd \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

ifeq ($(BR2_GCC_ENABLE_GRAPHITE),y)
HOST_GCC_BPF_DEPENDENCIES += host-isl
HOST_GCC_BPF_CONF_OPTS += --with-isl=$(HOST_DIR)
else
HOST_GCC_BPF_CONF_OPTS += --without-isl --without-cloog
endif

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
HOST_GCC_BPF_CONF_ENV = \
	MAKEINFO=missing

# Make sure we have 'cc'
define HOST_GCC_BPF_CREATE_CC_SYMLINKS
	if [ ! -e $(HOST_DIR)/bin/$(BPF_TARGET_NAME)-cc ]; then \
		ln -f $(HOST_DIR)/bin/$(BPF_TARGET_NAME)-gcc \
			$(HOST_DIR)/bin/$(BPF_TARGET_NAME)-cc; \
	fi
endef

HOST_GCC_BPF_POST_INSTALL_HOOKS += HOST_GCC_BPF_CREATE_CC_SYMLINKS

HOST_GCC_BPF_MAKE_OPTS = $(HOST_GCC_COMMON_MAKE_OPTS) all-gcc all-target-libgcc
HOST_GCC_BPF_INSTALL_OPTS = install-gcc install-target-libgcc

HOST_GCC_BPF_TOOLCHAIN_WRAPPER_ARGS = -DBR_SYSROOT='"$(STAGING_SUBDIR)"'
HOST_GCC_BPF_TOOLCHAIN_WRAPPER_ARGS += $(HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)

define HOST_GCC_BPF_TOOLCHAIN_WRAPPER_BUILD
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_GCC_BPF_TOOLCHAIN_WRAPPER_ARGS) \
		-s -Wl,--hash-style=$(TOOLCHAIN_WRAPPER_HASH_STYLE) \
		toolchain/toolchain-wrapper.c \
		-o $(@D)/toolchain-wrapper-bpf
endef

define HOST_GCC_BPF_TOOLCHAIN_WRAPPER_INSTALL
	$(INSTALL) -D -m 0755 $(@D)/toolchain-wrapper-bpf \
		$(HOST_DIR)/bin/toolchain-wrapper-bpf
endef

HOST_GCC_BPF_POST_BUILD_HOOKS += HOST_GCC_BPF_TOOLCHAIN_WRAPPER_BUILD
HOST_GCC_BPF_POST_INSTALL_HOOKS += HOST_GCC_BPF_TOOLCHAIN_WRAPPER_INSTALL

define HOST_GCC_BPF_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS
	$(Q)cd $(HOST_DIR)/bin; \
	for i in $(BPF_TARGET_NAME)-*; do \
		case "$$i" in \
		*.br_real) \
			;; \
		*-ar|*-ranlib|*-nm) \
			ln -snf $$i bpf$${i##$(BPF_TARGET_NAME)}; \
			;; \
		*cc|*cc-*|*++|*++-*|*cpp|*-gfortran|*-gdc) \
			rm -f $$i.br_real; \
			mv $$i $$i.br_real; \
			ln -sf toolchain-wrapper-bpf $$i; \
			ln -sf toolchain-wrapper-bpf bpf$${i##$(BPF_TARGET_NAME)}; \
			ln -snf $$i.br_real bpf$${i##$(BPF_TARGET_NAME)}.br_real; \
			;; \
		*) \
			ln -snf $$i bpf$${i##$(BPF_TARGET_NAME)}; \
			;; \
		esac; \
	done

endef

HOST_GCC_BPF_POST_INSTALL_HOOKS += HOST_GCC_BPF_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

$(eval $(host-autotools-package))
