################################################################################
#
# python-poetry-core
#
################################################################################

PYTHON_POETRY_CORE_VERSION = 1.9.0
PYTHON_POETRY_CORE_SOURCE = poetry_core-$(PYTHON_POETRY_CORE_VERSION).tar.gz
PYTHON_POETRY_CORE_SITE = https://files.pythonhosted.org/packages/f2/db/20a9f9cae3f3c213a8c406deb4395698459fd96962cea8f2ccb230b1943c
PYTHON_POETRY_CORE_SETUP_TYPE = pep517
PYTHON_POETRY_CORE_LICENSE = \
	Apache-2.0 or BSD-2-Clause (packaging), \
	BSD-3-Clause (fastjsonschema), \
	GPL-2.0-or-later (lark), \
	MIT (lark, poetry-core, tomli), \
	MPL-2.0 (lark)
PYTHON_POETRY_CORE_LICENSE_FILES = \
	LICENSE \
	src/poetry/core/_vendor/lark/LICENSE \
	src/poetry/core/_vendor/packaging/LICENSE \
	src/poetry/core/_vendor/tomli/LICENSE \
	src/poetry/core/_vendor/fastjsonschema/LICENSE

$(eval $(host-python-package))
