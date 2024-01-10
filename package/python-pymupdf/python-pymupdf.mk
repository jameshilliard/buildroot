################################################################################
#
# python-pymupdf
#
################################################################################

# python-pymupdf's version must match mupdf's version
PYTHON_PYMUPDF_VERSION = 1.23.9rc2
PYTHON_PYMUPDF_SOURCE = PyMuPDF-$(PYTHON_PYMUPDF_VERSION).tar.gz
PYTHON_PYMUPDF_SITE = https://files.pythonhosted.org/packages/b4/ff/db44303d60b8cc310a7187d500c7765b3b48aa113c86428d5d1c390b8fb5
PYTHON_PYMUPDF_SETUP_TYPE = pep517
PYTHON_PYMUPDF_LICENSE = AGPL-3.0+
PYTHON_PYMUPDF_LICENSE_FILES = COPYING
# No license file included in pip, but it's present on github
PYTHON_PYMUPDF_DEPENDENCIES = \
	host-python-libclang \
	host-python-psutil \
	host-python-setuptools \
	host-python-swig \
	host-swig \
	freetype \
	mupdf \
	zlib

PYTHON_PYMUPDF_ENV = \
	PYMUPDF_INCLUDES="$(STAGING_DIR)/usr/include/freetype2:$(STAGING_DIR)/usr/include" \
	PYMUPDF_MUPDF_LIB="$(STAGING_DIR)/usr/lib" \
	PYMUPDF_SETUP_FLAVOUR=p \
	PYMUPDF_SETUP_IMPLEMENTATIONS=a \
	PYMUPDF_SETUP_MUPDF_BUILD=

$(eval $(python-package))
