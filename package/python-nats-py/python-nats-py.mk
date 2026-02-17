################################################################################
#
# python-nats-py
#
################################################################################

PYTHON_NATS_PY_VERSION = 2.15.0
PYTHON_NATS_PY_SOURCE = nats_py-$(PYTHON_NATS_PY_VERSION).tar.gz
PYTHON_NATS_PY_SITE = https://files.pythonhosted.org/packages/02/f0/fc5e93f2b0dd14a202590ad9d30eda1955ea872039b5204357348d0f4b1e
PYTHON_NATS_PY_SETUP_TYPE = pep517
PYTHON_NATS_PY_LICENSE = Apache-2.0
PYTHON_NATS_PY_LICENSE_FILES = LICENSE
PYTHON_NATS_PY_BUILD_OPTS = --skip-dependency-check
PYTHON_NATS_PY_DEPENDENCIES = host-python-uv-build

$(eval $(python-package))
