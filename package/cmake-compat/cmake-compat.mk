################################################################################
#
# cmake-compat
#
################################################################################

CMAKE_COMPAT_VERSION_MAJOR = 3.9
CMAKE_COMPAT_VERSION = $(CMAKE_COMPAT_VERSION_MAJOR).6
CMAKE_COMPAT_SITE = https://cmake.org/files/v$(CMAKE_COMPAT_VERSION_MAJOR)
CMAKE_COMPAT_LICENSE = BSD-3-Clause
CMAKE_COMPAT_LICENSE_FILES = Copyright.txt

# CMake is a particular package:
# * CMake can be built using the generic infrastructure or the cmake one.
#   Since Buildroot has no requirement regarding the host system cmake
#   program presence, it uses the generic infrastructure to build the
#   host-cmake package, then the (target-)cmake package can be built
#   using the cmake infrastructure;
# * CMake bundles its dependencies within its sources. This is the
#   reason why the host-cmake package has no dependencies:, whereas
#   the (target-)cmake package has a lot of dependencies, using only
#   the system-wide libraries instead of rebuilding and statically
#   linking with the ones bundled into the CMake sources.

CMAKE_COMPAT_DEPENDENCIES = zlib jsoncpp libcurl libarchive expat bzip2 xz libuv rhash

CMAKE_COMPAT_CONF_OPTS = \
	-DKWSYS_LFS_WORKS=TRUE \
	-DKWSYS_CHAR_IS_SIGNED=TRUE \
	-DCMAKE_USE_SYSTEM_LIBRARIES=1 \
	-DCTEST_USE_XMLRPC=OFF \
	-DBUILD_CursesDialog=OFF

# Get rid of -I* options from $(HOST_CPPFLAGS) to prevent that a
# header available in $(HOST_DIR)/include is used instead of a
# CMake internal header, e.g. lzma* headers of the xz package
HOST_CMAKE_COMPAT_CFLAGS = $(shell echo $(HOST_CFLAGS) | sed -r "s%$(HOST_CPPFLAGS)%%")
HOST_CMAKE_COMPAT_CXXFLAGS = $(shell echo $(HOST_CXXFLAGS) | sed -r "s%$(HOST_CPPFLAGS)%%")

define HOST_CMAKE_COMPAT_CONFIGURE_CMDS
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CMAKE_COMPAT_CFLAGS)" \
		./bootstrap --prefix=$(HOST_DIR) \
			--parallel=$(PARALLEL_JOBS) -- \
			-DCMAKE_C_FLAGS="$(HOST_CMAKE_COMPAT_CFLAGS)" \
			-DCMAKE_CXX_FLAGS="$(HOST_CMAKE_COMPAT_CXXFLAGS)" \
			-DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
			-DCMAKE_USE_OPENSSL:BOOL=OFF \
			-DBUILD_CursesDialog=OFF \
	)
endef

define HOST_CMAKE_COMPAT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CMAKE_COMPAT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install/fast
endef

$(eval $(host-generic-package))
