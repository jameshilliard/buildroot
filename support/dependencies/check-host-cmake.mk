# Set this to either 3.10 or higher, depending on the highest minimum
# version required by any of the packages bundled in Buildroot. If a
# package is bumped or a new one added, and it requires a higher
# version, our cmake infra will catch it and build its own.
# Newer versions of cmake require a c++11 toolchain so we should
# only build newer versions if our host gcc supports c++11.
# Packages that depend upon newer cmake versions all currently
# require a c++11 toolchain themselves.
#
ifeq ($(BR2_HOST_GCC_AT_LEAST_4_8),y)
BR2_CMAKE_VERSION_MIN = 3.10
else
BR2_CMAKE_VERSION_MIN = 3.8
endif

BR2_CMAKE_CANDIDATES ?= cmake cmake3
BR2_CMAKE ?= $(call suitable-host-package,cmake,\
	$(BR2_CMAKE_VERSION_MIN) $(BR2_CMAKE_CANDIDATES))
ifeq ($(BR2_CMAKE),)
BR2_CMAKE = $(HOST_DIR)/bin/cmake
BR2_CMAKE_HOST_DEPENDENCY = host-cmake
endif
