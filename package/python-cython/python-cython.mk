################################################################################
#
# python-cython
#
################################################################################

PYTHON_CYTHON_VERSION = 3.0.8
PYTHON_CYTHON_SOURCE = Cython-$(PYTHON_CYTHON_VERSION).tar.gz
PYTHON_CYTHON_SITE = https://files.pythonhosted.org/packages/68/09/ffb61f29b8e3d207c444032b21328327d753e274ea081bc74e009827cc81
PYTHON_CYTHON_SETUP_TYPE = setuptools
PYTHON_CYTHON_LICENSE = Apache-2.0
PYTHON_CYTHON_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))
