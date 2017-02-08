#
# This file is part of trust|me
# Copyright(c) 2013 - 2017 Fraunhofer AISEC
# Fraunhofer-Gesellschaft zur Förderung der angewandten Forschung e.V.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms and conditions of the GNU General Public License,
# version 2 (GPL 2), as published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GPL 2 license for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>
#
# The full GNU General Public License is included in this distribution in
# the file called "COPYING".
#
# Contact Information:
# Fraunhofer AISEC <trustme@aisec.fraunhofer.de>
#

# Get the long list of APNs
PRODUCT_COPY_FILES := device/lge/hammerhead/apns-full-conf.xml:system/etc/apns-conf.xml

# Overwrite disabled functions with empty xml (needs to be done before anything else is included)
PRODUCT_COPY_FILES += \
    device/fraunhofer/trustme_generic/empty.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    device/fraunhofer/trustme_generic/empty.xml:system/etc/permissions/android.hardware.usb.host.xml
# Copy trustme specific handheld_core_hardware.xml (e.g., removed camera and bluetooth)
PRODUCT_COPY_FILES += \
    device/fraunhofer/trustme_generic/empty.xml:system/etc/permissions/handheld_core_hardware.xml \
    device/fraunhofer/trustme_generic/trustme_generic_hardware.xml:system/etc/permissions/trustme_generic_hardware.xml
# extracted features like bluetooth which can be cleaned by postprocessing in trustme-main.mk
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml

# Copy audio config with disabled offload device (due to missing kernel namespace)
PRODUCT_COPY_FILES += \
    device/fraunhofer/trustme_hammerhead_aX/audio_policy.conf:system/etc/audio_policy.conf \
    device/fraunhofer/trustme_hammerhead_aX/mixer_paths.xml:system/etc/mixer_paths.xml

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# overlay needs to be defined before generic or hardware include/inherit to take precedence
DEVICE_PACKAGE_OVERLAYS += device/fraunhofer/trustme_hammerhead_aX/overlay

# Enable the Google network and fused location providers
PRODUCT_PACKAGE_OVERLAYS += device/sample/overlays/location
PRODUCT_PACKAGES += NetworkLocation

## overwrite dalvik parameters with values for a 1GB device
#$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

# Inherit from hammerhead device
$(call inherit-product, device/lge/hammerhead/device.mk)

# do not use binarie from any device specicifc hammerhead-kernel.git
TARGET_PREBUILT_KERNEL := device/fraunhofer/trustme_hammerhead_aX/dummy_kernel

include device/fraunhofer/trustme_generic/trustme_generic_aX.mk

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := trustme_hammerhead_aX
PRODUCT_DEVICE := trustme_hammerhead_aX
PRODUCT_BRAND := Android
PRODUCT_MODEL := trust-me AndroidX for hammerhead
PRODUCT_MANUFACTURER := fraunhofer
PRODUCT_MODEL := hammerhead
OUT_DIR := out-aosp

PRODUCT_COPY_FILES += \
    device/fraunhofer/trustme_hammerhead_aX/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    external/dhcpcd/android.conf:system/etc/dhcpcd/dhcpcd.conf

# include binary blobs
$(call inherit-product-if-exists, vendor/lge/hammerhead/device-vendor.mk)
$(call inherit-product-if-exists, vendor/lge/hammerhead/hammerhead-vendor.mk)
