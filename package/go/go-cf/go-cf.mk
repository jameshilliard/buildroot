################################################################################
#
# go-cf
#
################################################################################

GO_CF_VERSION = ec0a014545f180b0c74dfd687698657a9e86e310
GO_CF_SITE = $(call github,cloudflare,go,$(GO_CF_VERSION))

GO_CF_LICENSE = BSD-3-Clause
GO_CF_LICENSE_FILES = LICENSE

HOST_GO_CF_ROOT = $(HOST_DIR)/lib/go-cf

# We pass an empty GOBIN, otherwise "go install: cannot install
# cross-compiled binaries when GOBIN is set"
HOST_GO_CF_COMMON_ENV = \
	GO111MODULE=on \
	GOFLAGS=-mod=vendor \
	GOROOT="$(HOST_GO_CF_ROOT)" \
	GOPATH="$(HOST_GO_GOPATH)" \
	GOCACHE="$(HOST_GO_TARGET_CACHE)" \
	GOMODCACHE="$(HOST_GO_CF_ROOT)/pkg/mod" \
	GOPROXY=off \
	GOTOOLCHAIN=local \
	PATH=$(BR_PATH) \
	GOBIN= \
	CGO_ENABLED=$(HOST_GO_CGO_ENABLED)

# For the convenience of target packages.
HOST_GO_CF_TOOLDIR = $(HOST_GO_CF_ROOT)/pkg/tool/linux_$(GO_GOARCH)
HOST_GO_CF_TARGET_ENV = \
	$(HOST_GO_CF_COMMON_ENV) \
	GOOS="linux" \
	GOARCH=$(GO_GOARCH) \
	$(if $(GO_GO386),GO386=$(GO_GO386)) \
	$(if $(GO_GOARM),GOARM=$(GO_GOARM)) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	CGO_CFLAGS="$(TARGET_CFLAGS)" \
	CGO_CXXFLAGS="$(TARGET_CXXFLAGS)" \
	CGO_LDFLAGS="$(TARGET_LDFLAGS)" \
	GOTOOLDIR="$(HOST_GO_CF_TOOLDIR)"

HOST_GO_CF_DEPENDENCIES = host-go

ifeq ($(BR2_PACKAGE_HOST_GO_TARGET_ARCH_SUPPORTS),y)

HOST_GO_CF_CROSS_ENV = \
	CC_FOR_TARGET="$(TARGET_CC)" \
	CXX_FOR_TARGET="$(TARGET_CXX)" \
	GOOS="linux" \
	GOARCH=$(GO_GOARCH) \
	$(if $(GO_GO386),GO386=$(GO_GO386)) \
	$(if $(GO_GOARM),GOARM=$(GO_GOARM)) \
	GO_ASSUME_CROSSCOMPILING=1

endif

# The go build system is not compatible with ccache, so use
# HOSTCC_NOCCACHE.  See https://github.com/golang/go/issues/11685.
HOST_GO_CF_MAKE_ENV = \
	GO111MODULE=off \
	GOCACHE=$(HOST_GO_HOST_CACHE) \
	GOROOT_BOOTSTRAP=$(HOST_GO_ROOT) \
	GOROOT_FINAL=$(HOST_GO_CF_ROOT) \
	GOROOT="$(@D)" \
	GOBIN="$(@D)/bin" \
	GOOS=linux \
	CC=$(HOSTCC_NOCCACHE) \
	CXX=$(HOSTCXX_NOCCACHE) \
	CGO_ENABLED=$(HOST_GO_CGO_ENABLED) \
	$(HOST_GO_CF_CROSS_ENV)

define HOST_GO_CF_BUILD_CMDS
	cd $(@D)/src && \
		$(HOST_GO_CF_MAKE_ENV) ./make.bash $(if $(VERBOSE),-v)
endef

define HOST_GO_CF_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/go $(HOST_GO_CF_ROOT)/bin/go
	$(INSTALL) -D -m 0755 $(@D)/bin/gofmt $(HOST_GO_CF_ROOT)/bin/gofmt

	mkdir -p $(HOST_DIR)/bin
	ln -sf ../lib/go-cf/bin/go $(HOST_DIR)/bin/go-cf

	cp -a $(@D)/lib $(HOST_GO_CF_ROOT)/

	mkdir -p $(HOST_GO_CF_ROOT)/pkg
	cp -a $(@D)/pkg/include $(HOST_GO_CF_ROOT)/pkg/
	cp -a $(@D)/pkg/tool $(HOST_GO_CF_ROOT)/pkg/

	# The Go sources must be installed to the host/ tree for the Go stdlib.
	cp -a $(@D)/src $(HOST_GO_CF_ROOT)/

	# Set file timestamps to prevent the Go compiler from rebuilding the stdlib
	# when compiling other programs.
	find $(HOST_GO_CF_ROOT) -type f -exec touch -r $(@D)/bin/go {} \;
endef

$(eval $(host-generic-package))
