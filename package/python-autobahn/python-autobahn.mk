################################################################################
#
# python-autobahn
#
################################################################################

PYTHON_AUTOBAHN_VERSION = 20.6.2
PYTHON_AUTOBAHN_SOURCE = autobahn-$(PYTHON_AUTOBAHN_VERSION).tar.gz
PYTHON_AUTOBAHN_SITE = https://files.pythonhosted.org/packages/43/ba/926d323decdce0341f6f60dce45ea5553b08113dddb9ca482554d3db11eb
PYTHON_AUTOBAHN_LICENSE = MIT
PYTHON_AUTOBAHN_LICENSE_FILES = LICENSE
PYTHON_AUTOBAHN_SETUP_TYPE = setuptools
PYTHON_AUTOBAHN_DEPENDENCIES = host-python-cffi
PYTHON_AUTOBAHN_ENV = AUTOBAHN_USE_NVX=1 AUTOBAHN_STRIP_XBR=1

define PYTHON_AUTOBAHN_STRIP_XBR_CONTRACTS
	rm -rf $(@D)/autobahn/xbr/contracts
endef

PYTHON_AUTOBAHN_POST_EXTRACT_HOOKS = PYTHON_AUTOBAHN_STRIP_XBR_CONTRACTS

$(eval $(python-package))
