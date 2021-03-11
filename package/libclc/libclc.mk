################################################################################
#
# libclc
#
################################################################################

LIBCLC_VERSION = 11.1.0
LIBCLC_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LIBCLC_VERSION)
LIBCLC_SOURCE = libclc-$(LIBCLC_VERSION).src.tar.xz
LIBCLC_LICENSE = Apache-2.0 with exceptions or MIT
LIBCLC_LICENSE_FILES = LICENSE.TXT

LIBCLC_DEPENDENCIES = host-clang host-llvm
LIBCLC_INSTALL_STAGING = YES

# CMAKE_*_COMPILER_FORCED=ON skips testing the tools and assumes
# llvm-config provided values
#
# CMAKE_CXX_COMPILER has to be set to the host compiler to build a host
# 'prepare_builtins' tool used during the build process
LIBCLC_CONF_OPTS = \
	-DCMAKE_CLC_COMPILER_FORCED=ON \
	-DCMAKE_LLAsm_COMPILER_FORCED=ON \
	-DCMAKE_CXX_COMPILER="$(CMAKE_HOST_CXX_COMPILER)"

$(eval $(cmake-package))
