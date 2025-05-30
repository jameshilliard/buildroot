################################################################################
#
# tpm2-pkcs11
#
################################################################################

TPM2_PKCS11_VERSION = 1.9.1
TPM2_PKCS11_SITE = https://github.com/tpm2-software/tpm2-pkcs11/releases/download/$(TPM2_PKCS11_VERSION)
TPM2_PKCS11_LICENSE = BSD-2-Clause
TPM2_PKCS11_LICENSE_FILES = LICENSE
TPM2_PKCS11_DEPENDENCIES = host-pkgconf libyaml openssl sqlite tpm2-tss

TPM2_PKCS11_CONF_OPTS += \
		--disable-hardening \
		--disable-ptool-checks

# Fix tpm.c:746:5: error: 'for' loop initial declarations are only allowed in C99 mode
# Fix implicit declaration of function 'strnlen'
TPM2_PKCS11_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

# do not build man pages
TPM2_PKCS11_CONF_ENV += ac_cv_prog_PANDOC=''

# tpm2-pkcs11 checks for tpm2-tools programs and errors out if not
# found, even though they are only used by the (unused in Buildroot)
# python-based tools
TPM2_PKCS11_CONF_ENV += \
	ac_cv_prog_tpm2_createprimary=yes \
	ac_cv_prog_tpm2_create=yes \
	ac_cv_prog_tpm2_evictcontrol=yes \
	ac_cv_prog_tpm2_readpublic=yes \
	ac_cv_prog_tpm2_load=yes \
	ac_cv_prog_tpm2_loadexternal=yes \
	ac_cv_prog_tpm2_unseal=yes \
	ac_cv_prog_tpm2_encryptdecrypt=yes \
	ac_cv_prog_tpm2_sign=yes \
	ac_cv_prog_tpm2_getcap=yes \
	ac_cv_prog_tpm2_import=yes \
	ac_cv_prog_tpm2_changeauth=yes

ifeq ($(BR2_PACKAGE_P11_KIT),y)
TPM2_PKCS11_DEPENDENCIES += p11-kit
TPM2_PKCS11_CONF_OPTS += \
	--with-p11kitconfigdir=/usr/share/p11-kit/modules
endif

ifeq ($(BR2_PACKAGE_TPM2_PKCS11_PYTHON_TOOLS),y)
TPM2_PKCS11_DEPENDENCIES += python-tpm2-pytss

define TPM2_PKCS11_BUILD_TOOLS
	(cd $(@D)/tools; \
	$(PKG_PYTHON_SETUPTOOLS_ENV) \
		$(HOST_DIR)/bin/python setup.py build)
endef
TPM2_PKCS11_POST_BUILD_HOOKS += TPM2_PKCS11_BUILD_TOOLS

define TPM2_PKCS11_INSTALL_TARGET_TOOLS
	(cd $(@D)/tools; \
	$(PKG_PYTHON_SETUPTOOLS_ENV) \
		$(HOST_DIR)/bin/python setup.py install \
		$(PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS) \
		--root=$(TARGET_DIR))
endef
TPM2_PKCS11_POST_INSTALL_TARGET_HOOKS += TPM2_PKCS11_INSTALL_TARGET_TOOLS
endif

$(eval $(autotools-package))
