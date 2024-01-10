################################################################################
#
# python-swig
#
################################################################################

PYTHON_SWIG_VERSION = 4.1.1.post1
PYTHON_SWIG_SOURCE = swig-$(PYTHON_SWIG_VERSION).tar.gz
PYTHON_SWIG_SITE = https://files.pythonhosted.org/packages/da/b8/d1bfba3d7f75eeca60ecdcb2c214e5cdebb7477437d45db77b6dafee80f9
PYTHON_SWIG_SETUP_TYPE = setuptools
PYTHON_SWIG_LICENSE = Apache-2.0
PYTHON_SWIG_LICENSE_FILES = LICENSE
HOST_PYTHON_SWIG_DEPENDENCIES = \
	host-python-scikit-build \
	host-python-setuptools-scm

$(eval $(host-python-package))
