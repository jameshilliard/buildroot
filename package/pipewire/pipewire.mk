################################################################################
#
# pipewire
#
################################################################################

PIPEWIRE_VERSION = 0.2.92
PIPEWIRE_SITE = $(call github,PipeWire,pipewire,$(PIPEWIRE_VERSION))
PIPEWIRE_LICENSE = LGPL-2.1+
PIPEWIRE_LICENSE_FILES = LICENSE LGPL
PIPEWIRE_INSTALL_STAGING = YES
PIPEWIRE_DEPENDENCIES = host-pkgconf alsa-lib dbus udev

PIPEWIRE_CONF_OPTS += \
	-Dman=false \
	-Dspa-plugins=false \
	-Dalsa=false \
	-Daudiomixer=false \
	-Daudioconvert=false \
	-Dbluez5=false \
	-Dcontrol=false \
	-Djack=false \
	-Dsupport=false \
	-Dv4l2=false \
	-Dvideoconvert=false \
	-Dvulkan=false \
	-Dexamples=false

ifeq ($(BR2_PACKAGE_FFMPEG),y)
PIPEWIRE_DEPENDENCIES += ffmpeg
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
PIPEWIRE_DEPENDENCIES += libva
endif

ifeq ($(BR2_PACKAGE_SBC),y)
PIPEWIRE_DEPENDENCIES += sbc
endif

ifeq ($(BR2_PACKAGE_SDL2),y)
PIPEWIRE_DEPENDENCIES += sdl2
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
PIPEWIRE_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
PIPEWIRE_CONF_OPTS += -Dpipewire-alsa=true
PIPEWIRE_DEPENDENCIES += alsa-lib
else
PIPEWIRE_CONF_OPTS += -Dpipewire-alsa=false
endif

ifeq ($(BR2_PACKAGE_JACK2),y)
PIPEWIRE_CONF_OPTS += -Dpipewire-jack=true
PIPEWIRE_DEPENDENCIES += jack2
else
PIPEWIRE_CONF_OPTS += -Dpipewire-jack=false
endif

ifeq ($(BR2_PACKAGE_PIPEWIRE_GSTREAMER),y)
PIPEWIRE_CONF_OPTS += -Dgstreamer=true
PIPEWIRE_DEPENDENCIES += libglib2 gstreamer1 gst1-plugins-base
else
PIPEWIRE_CONF_OPTS += -Dgstreamer=false
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
PIPEWIRE_CONF_OPTS += -Dpipewire-pulseaudio=true
PIPEWIRE_DEPENDENCIES += pulseaudio
else
PIPEWIRE_CONF_OPTS += -Dpipewire-pulseaudio=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PIPEWIRE_CONF_OPTS += -Dsystemd=true
PIPEWIRE_DEPENDENCIES += systemd
else
PIPEWIRE_CONF_OPTS += -Dsystemd=false
endif

$(eval $(meson-package))
