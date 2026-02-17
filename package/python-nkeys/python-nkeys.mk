################################################################################
#
# python-nkeys
#
################################################################################

PYTHON_NKEYS_VERSION = 0.2.1
PYTHON_NKEYS_SOURCE = nkeys-$(PYTHON_NKEYS_VERSION).tar.gz
PYTHON_NKEYS_SITE = https://files.pythonhosted.org/packages/e1/8d/d17254baea57fe4a7dd1ba89827d3cf0a21106988ec8971a46bfc5239b15
PYTHON_NKEYS_SETUP_TYPE = setuptools
PYTHON_NKEYS_LICENSE = Apache-2.0
PYTHON_NKEYS_LICENSE_FILES = LICENSE

$(eval $(python-package))
