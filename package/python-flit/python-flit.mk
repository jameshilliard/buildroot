################################################################################
#
# python-flit
#
################################################################################

PYTHON_FLIT_VERSION = 3.5.1
PYTHON_FLIT_SOURCE = flit-$(PYTHON_FLIT_VERSION).tar.gz
PYTHON_FLIT_SITE = https://files.pythonhosted.org/packages/a8/bc/4bbb98f1ce0ae4e778f3486c39c487a066d69f5ffe4e762c79664dfd5df8
PYTHON_FLIT_SETUP_TYPE = flit
PYTHON_FLIT_LICENSE = BSD-3-Clause
PYTHON_FLIT_LICENSE_FILES = LICENSE
HOST_PYTHON_FLIT_NEEDS_HOST_PYTHON = python3
HOST_PYTHON_FLIT_DEPENDENCIES = host-python-docutils host-python-tomli
HOST_PYTHON_FLIT_ENV = PYTHONPATH="$(PYTHON3_PATH):$(@D):$(@D)/flit_core"

$(eval $(host-python-package))
