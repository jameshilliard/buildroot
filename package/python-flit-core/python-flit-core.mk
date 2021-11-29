################################################################################
#
# python-flit-core
#
################################################################################

PYTHON_FLIT_CORE_VERSION = 3.5.1
PYTHON_FLIT_CORE_SOURCE = flit_core-$(PYTHON_FLIT_CORE_VERSION).tar.gz
PYTHON_FLIT_CORE_SITE = https://files.pythonhosted.org/packages/7e/1e/15198966abf00e590ec95fb8aa4ba3d274897fe7b182fce2867f672f6a91
PYTHON_FLIT_CORE_SETUP_TYPE = flit
PYTHON_FLIT_CORE_LICENSE = BSD-3-Clause
HOST_PYTHON_FLIT_CORE_NEEDS_HOST_PYTHON = python3
HOST_PYTHON_FLIT_CORE_DEPENDENCIES = host-python-flit
HOST_PYTHON_FLIT_CORE_ENV = PYTHONPATH="$(PYTHON3_PATH):$(@D)"

define HOST_PYTHON_FLIT_CORE_FLIT_GENERATE_SETUP
	cd $(HOST_PYTHON_FLIT_CORE_BUILDDIR)/; \
		$(HOST_PYTHON_FLIT_CORE_BASE_ENV) $(HOST_PYTHON_FLIT_CORE_ENV) \
		$(HOST_PYTHON_FLIT_CORE_PYTHON_INTERPRETER) -c \
		"import sys; \
		sys.modules['requests'] = False; \
		from flit.sdist import SdistBuilder; \
		from flit_core.build_thyself import metadata, Module; \
		from pathlib import Path; \
		cwd=Path.cwd(); \
		module=Module('flit_core', cwd); \
		reqs_by_extra={'.none': metadata.requires}; \
		extra_files=['pyproject.toml', 'build_dists.py']; \
		setup=cwd.joinpath('setup.py').open('wb'); \
		builder=SdistBuilder(module, metadata, cwd, reqs_by_extra, {}, extra_files); \
		setup.write(builder.make_setup_py())"
endef

$(eval $(host-python-package))
