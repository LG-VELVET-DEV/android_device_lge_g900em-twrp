#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

LOCAL_PATH := device/lge/g900em

BOARD_VENDOR := lge

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a75

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := lito
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

BUILD_BROKEN_DUP_RULES := true

# Kernel
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_PREBUILT_DTB := $(LOCAL_PATH)/prebuilt/dtb.img
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/prebuilt/Image.gz
BOARD_PREBUILT_DTBOIMAGE := $(LOCAL_PATH)/prebuilt/dtbo.img
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_BASE          := 0x00000000
BOARD_KERNEL_TAGS_OFFSET   := 0x00000100
BOARD_KERNEL_OFFSET        := 0x00008000
BOARD_KERNEL_SECOND_OFFSET := 0x00f00000
BOARD_RAMDISK_OFFSET       := 0x01000000
BOARD_DTB_OFFSET           := 0x01f00000
BOARD_KERNEL_CMDLINE += androidboot.memcg=1
BOARD_KERNEL_CMDLINE += lpm_levels.sleep_disabled=1
BOARD_KERNEL_CMDLINE += video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237
BOARD_KERNEL_CMDLINE += msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware_mnt/image
BOARD_KERNEL_CMDLINE += loop.max_part=7 androidboot.usbcontroller=a600000.dwc3
BOARD_KERNEL_CMDLINE += swapaccount=0 dhash_entries=131072 ihash_entries=131072
BOARD_KERNEL_CMDLINE += androidboot.hardware=caymanlm
BOARD_KERNEL_CMDLINE += buildvariant=user
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_KERNEL_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)

# Platform
TARGET_BOARD_PLATFORM := lito
TARGET_BOARD_PLATFORM_GPU := qcom-adreno620
QCOM_BOARD_PLATFORMS += lito

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_USERDATAIMAGE_PARTITION_SIZE := 115601780736
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

#super
PRODUCT_USE_DYNAMIC_PARTITIONS := true
#PRODUCT_BUILD_SUPER_PARTITION := true
BOARD_SUPER_PARTITION_SIZE := 21474836480
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 10733223936
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    product \
    vendor

# Partitions (listed in the file) to be wiped under recovery.
TARGET_RECOVERY_WIPE := $(LOCAL_PATH)/recovery.wipe
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery.fstab

# Workaround for error copying vendor files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# QCOM
BOARD_USES_QCOM_HARDWARE := true
TARGET_USES_QCOM_BSP := true

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
AB_OTA_UPDATER := true

TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := false
#BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# more partitions to this list for the bootloader and radio.
AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor \
    vbmeta \
    dtbo

# TWRP specific build flags
RECOVERY_SDCARD_ON_DATA := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 511
TW_DEFAULT_BRIGHTNESS := 130
TW_Y_OFFSET := 90
TW_H_OFFSET := -90
TW_THEME := portrait_hdpi

TW_HAPTICS_TSPDRV := true

TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_SUPERSU := true
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_NTFS_3G := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_HAS_EDL_MODE := false

TARGET_RECOVERY_DEVICE_MODULES += android.hardware.boot@1.0

TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_NO_SCREEN_BLANK := true
TW_USE_TOOLBOX := true
TW_EXCLUDE_TWRPAPP := true
USE_RECOVERY_INSTALLER := true
TW_INCLUDE_REPACKTOOLS := true

BOARD_SUPPRESS_SECURE_ERASE := true

# We can use the factory reset button combo to enter recovery safely
TW_IGNORE_MISC_WIPE_DATA := true

# Custom Platform Version and Security Patch
# TWRP Defaults
#PLATFORM_VERSION := 16.1.0
#PLATFORM_SECURITY_PATCH := 2025-12-05
# Must match build.prop of current system for vold decrypt to work properly!
PLATFORM_VERSION := 16.1.0
# OTA V500EM v20e
PLATFORM_SECURITY_PATCH := 2020-09-01

# Crypto
#TW_INCLUDE_CRYPTO := true
TARGET_HW_DISK_ENCRYPTION := true
TW_CRYPTO_USE_SYSTEM_VOLD := qseecomd

# TWRP Debug Flags
#TWRP_EVENT_LOGGING := true
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
#TARGET_RECOVERY_DEVICE_MODULES += debuggerd strace
#TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(OUT)/system/bin/debuggerd $(OUT)/system/xbin/strace
#TARGET_RECOVERY_DEVICE_MODULES += twrpdec
#TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/twrpdec
TW_CRYPTO_SYSTEM_VOLD_DEBUG := true
