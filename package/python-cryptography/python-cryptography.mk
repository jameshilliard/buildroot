################################################################################
#
# python-cryptography
#
################################################################################

PYTHON_CRYPTOGRAPHY_VERSION = 3.4.6
PYTHON_CRYPTOGRAPHY_SOURCE = cryptography-$(PYTHON_CRYPTOGRAPHY_VERSION).tar.gz
PYTHON_CRYPTOGRAPHY_SITE = https://files.pythonhosted.org/packages/fa/2d/2154d8cb773064570f48ec0b60258a4522490fcb115a6c7c9423482ca993
PYTHON_CRYPTOGRAPHY_SETUP_TYPE = setuptools
PYTHON_CRYPTOGRAPHY_LICENSE = Apache-2.0 or BSD-3-Clause
PYTHON_CRYPTOGRAPHY_LICENSE_FILES = LICENSE LICENSE.APACHE LICENSE.BSD
PYTHON_CRYPTOGRAPHY_DEPENDENCIES = host-python-setuptools-rust host-python-cffi host-rustc
PYTHON_CRYPTOGRAPHY_ENV = CARGO_BUILD_TARGET="$(RUSTC_TARGET_NAME)" \
	PYO3_CROSS_LIB_DIR="$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)" \
	CARGO_HOME="$(HOST_DIR)/share/cargo"

$(eval $(python-package))
