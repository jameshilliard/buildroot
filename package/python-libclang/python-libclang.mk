################################################################################
#
# python-libclang
#
################################################################################

PYTHON_LIBCLANG_VERSION = 16.0.6
PYTHON_LIBCLANG_SOURCE = libclang-$(PYTHON_LIBCLANG_VERSION).tar.gz
PYTHON_LIBCLANG_SITE = https://files.pythonhosted.org/packages/c2/01/ec65dffc8c94bd8cafd359a76992f3212a239a80ead05522995c105432b8
PYTHON_LIBCLANG_SETUP_TYPE = setuptools
PYTHON_LIBCLANG_LICENSE = Apache-2.0
PYTHON_LIBCLANG_LICENSE_FILES = LICENSE.TXT

$(eval $(host-python-package))
