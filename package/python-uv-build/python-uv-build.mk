################################################################################
#
# python-uv-build
#
################################################################################

PYTHON_UV_BUILD_VERSION = 0.11.20
PYTHON_UV_BUILD_SOURCE_PYPI = uv_build-$(PYTHON_UV_BUILD_VERSION).tar.gz
PYTHON_UV_BUILD_SITE = $(PYTHON_UV_BUILD_SITE_PYPI)/$(PYTHON_UV_BUILD_SOURCE_PYPI)?buildroot-path=filename
PYTHON_UV_BUILD_SITE_PYPI = https://files.pythonhosted.org/packages/ab/4a/61c2db7c24c879155ea06a78930f2c71a9a6241154fe46de27af3219a73e
PYTHON_UV_BUILD_SETUP_TYPE = maturin
PYTHON_UV_BUILD_LICENSE = MIT or Apache-2.0
PYTHON_UV_BUILD_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

$(eval $(host-python-package))
