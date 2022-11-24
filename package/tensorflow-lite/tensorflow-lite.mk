################################################################################
#
# tensorflow-lite
#
################################################################################

TENSORFLOW_LITE_VERSION = 2.11.0
TENSORFLOW_LITE_SITE =  $(call github,tensorflow,tensorflow,v$(TENSORFLOW_LITE_VERSION))
TENSORFLOW_LITE_INSTALL_STAGING = YES
TENSORFLOW_LITE_LICENSE = Apache-2.0
TENSORFLOW_LITE_LICENSE_FILES = LICENSE
TENSORFLOW_LITE_SUBDIR = tensorflow/lite
TENSORFLOW_LITE_SUPPORTS_IN_SOURCE_BUILD = NO
TENSORFLOW_LITE_DEPENDENCIES += \
	host-pkgconf \
	host-flatbuffers \
	cpuinfo \
	eigen \
	farmhash \
	fft2d \
	flatbuffers \
	gemmlowp \
	libabseil-cpp \
	neon-2-sse \
	ruy

TENSORFLOW_LITE_CONF_OPTS = \
	-Dabsl_DIR=$(STAGING_DIR)/usr/lib/cmake/absl \
	-DBUILD_SHARED_LIBS=ON \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -I$(STAGING_DIR)/usr/include/gemmlowp" \
	-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DEigen3_DIR=$(STAGING_DIR)/usr/share/eigen3/cmake \
	-DFARMHASH_SOURCE_DIR=$(FARMHASH_DIR) \
	-Dfarmhash_DIR=$(STAGING_DIR)/usr/lib \
	-DFETCHCONTENT_FULLY_DISCONNECTED=ON \
	-DFETCHCONTENT_QUIET=OFF \
	-DFFT2D_SOURCE_DIR=$(STAGING_DIR)/usr/include/fft2d \
	-DFlatBuffers_DIR=$(STAGING_DIR)/usr/lib/cmake/flatbuffers \
	-DNEON_2_SSE_DIR=$(STAGING_DIR)/usr/lib/cmake/NEON_2_SSE \
	-DTFLITE_ENABLE_EXTERNAL_DELEGATE=ON \
	-DTFLITE_ENABLE_GPU=OFF \
	-DTFLITE_ENABLE_INSTALL=ON \
	-DTFLITE_ENABLE_MMAP=ON \
	-DTFLITE_ENABLE_NNAPI=ON \
	-DTFLITE_ENABLE_RUY=ON \
	-DTFLITE_ENABLE_XNNPACK=OFF

$(eval $(cmake-package))
