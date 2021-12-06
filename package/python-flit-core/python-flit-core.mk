################################################################################
#
# python-flit-core
#
################################################################################

PYTHON_FLIT_CORE_VERSION = 3.5.1
PYTHON_FLIT_CORE_SOURCE = flit_core-$(PYTHON_FLIT_CORE_VERSION)-py3-none-any.whl
PYTHON_FLIT_CORE_SITE = https://files.pythonhosted.org/packages/32/56/f3e180eea51e3e085b1da06233f6e6aa9adb04000d19ba91c29e44823bf7
PYTHON_FLIT_CORE_SETUP_TYPE = wheel
PYTHON_FLIT_CORE_LICENSE = BSD-3-Clause
HOST_PYTHON_FLIT_CORE_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
