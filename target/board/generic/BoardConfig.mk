# config.mk
#
# Product-specific compile-time definitions.
#

# The generic product target doesn't have any hardware-specific pieces.
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := true
TARGET_ARCH := arm

# Note: Before Pi, we built the platform images for ARMv7-A _without_ NEON.
#
ifneq ($(TARGET_BUILD_APPS)$(filter cts sdk,$(MAKECMDGOALS)),)
# DO NOT USE
#
# This architecture variant should NOT be used for 32 bit arm platform
# builds. It is the lowest common denominator required to build
# an unbundled application for all supported 32 platforms.
# cts for 32 bit arm is built using aosp_arm64 product.
#
# If you are building a 32 bit platform (and not an application),
# you should set the following as 2nd arch variant:
#
# TARGET_ARCH_VARIANT := armv7-a-neon
#
# DO NOT USE
TARGET_ARCH_VARIANT := armv7-a
# DO NOT USE
else
# Starting from Pi, System image of aosp_arm products is the new GSI
# for real devices newly launched for Pi. These devices are usualy not
# as performant as the mainstream 64-bit devices and the performance
# provided by NEON is important for them to pass related CTS tests.
TARGET_ARCH_VARIANT := armv7-a-neon
endif
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
HAVE_HTC_AUDIO_DRIVER := true
BOARD_USES_GENERIC_AUDIO := true
TARGET_BOOTLOADER_BOARD_NAME := goldfish_$(TARGET_ARCH)

TARGET_USES_64_BIT_BINDER := true

# no hardware camera
USE_CAMERA_STUB := true

TARGET_USES_HWC2 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Build OpenGLES emulation guest and host libraries
BUILD_EMULATOR_OPENGL := true
BUILD_QEMU_IMAGES := true

# Build and enable the OpenGL ES View renderer. When running on the emulator,
# the GLES renderer disables itself if host GL acceleration isn't available.
USE_OPENGL_RENDERER := true

TARGET_USERIMAGES_USE_EXT4 := true
# Partition size is default 1.5GB (1536MB) for 64 bits projects
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1610612736
BOARD_USERDATAIMAGE_PARTITION_SIZE := 576716800
TARGET_COPY_OUT_VENDOR := vendor
# ~100 MB vendor image. Please adjust system image / vendor image sizes
# when finalizing them.
BOARD_VENDORIMAGE_PARTITION_SIZE := 100000000
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 512
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
DEVICE_MATRIX_FILE   := device/generic/goldfish/compatibility_matrix.xml

BOARD_SEPOLICY_DIRS += device/generic/goldfish/sepolicy/common
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
# GSI is always userdebug and needs a couple of properties taking precedence
# over those set by the vendor.
TARGET_SYSTEM_PROP := build/make/target/board/gsi_system.prop
endif
BOARD_VNDK_VERSION := current

# Enable A/B update
TARGET_NO_RECOVERY := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

BOARD_VNDK_VERSION := current

BUILD_BROKEN_DUP_RULES := false
