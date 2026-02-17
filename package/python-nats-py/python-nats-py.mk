################################################################################
#
# python-nats-py
#
################################################################################

PYTHON_NATS_PY_VERSION = 2.13.1
PYTHON_NATS_PY_SOURCE = nats_py-$(PYTHON_NATS_PY_VERSION).tar.gz
PYTHON_NATS_PY_SITE = https://files.pythonhosted.org/packages/c2/70/e08fa8c2c15c9cc458bdf121019df1b9101e32602a408d94953fe1246300
PYTHON_NATS_PY_SETUP_TYPE = setuptools
PYTHON_NATS_PY_LICENSE = Apache-2.0

$(eval $(python-package))
