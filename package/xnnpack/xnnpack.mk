################################################################################
#
# xnnpack
#
################################################################################

XNNPACK_VERSION = 1f7f6131f7be587d0a657d03bdd0161d67ba2700
XNNPACK_SITE = $(call github,google,XNNPACK,$(XNNPACK_VERSION))
XNNPACK_LICENSE = BSD-3-Clause
XNNPACK_LICENSE_FILES = LICENSE
XNNPACK_INSTALL_STAGING = YES
XNNPACK_DEPENDENCIES = cpuinfo fp16 fxdiv pthreadpool
XNNPACK_CONF_OPTS = \
	-DXNNPACK_BUILD_TESTS=OFF \
	-DXNNPACK_BUILD_BENCHMARKS=OFF \
	-DXNNPACK_USE_SYSTEM_LIBS=ON

$(eval $(cmake-package))
