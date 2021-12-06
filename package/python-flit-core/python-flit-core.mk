################################################################################
#
# python-flit-core
#
################################################################################

PYTHON_FLIT_CORE_VERSION = 3.5.1
PYTHON_FLIT_CORE_SOURCE = flit_core-$(PYTHON_FLIT_CORE_VERSION).tar.gz
PYTHON_FLIT_CORE_SITE = https://files.pythonhosted.org/packages/7e/1e/15198966abf00e590ec95fb8aa4ba3d274897fe7b182fce2867f672f6a91
PYTHON_FLIT_CORE_SETUP_TYPE = pep517
PYTHON_FLIT_CORE_LICENSE = BSD-3-Clause
HOST_PYTHON_FLIT_CORE_NEEDS_HOST_PYTHON = python3
HOST_PYTHON_FLIT_CORE_DEPENDENCIES = host-python-pypa-build

$(eval $(host-python-package))
