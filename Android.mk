# Copyright 2006 The Android Open Source Project
LOCAL_PATH:= $(call my-dir)

etc_dir := $(TARGET_OUT)/etc/dhcpcd
hooks_dir := dhcpcd-hooks
hooks_target := $(etc_dir)/$(hooks_dir)

dhcpd_cflags := -D_BSD_SOURCE
# Clang complains about configure.c's comparing array with null.
dhcpd_cflags += -Wno-tautological-pointer-compare

include $(CLEAR_VARS)
LOCAL_SRC_FILES := arp.c bind.c common.c control.c dhcp.c dhcpcd.c duid.c \
	eloop.c if-options.c if-pref.c ipv4ll.c net.c signals.c configure.c \
	if-linux.c if-linux-wireless.c lpf.c \
	platform-linux.c compat/closefrom.c ifaddrs.c ipv6rs.c

LOCAL_CFLAGS := $(dhcpd_cflags)
LOCAL_SHARED_LIBRARIES := libc libcutils libnetutils
LOCAL_MODULE = dhcpcd
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := showlease.c
LOCAL_SHARED_LIBRARIES := libc
LOCAL_MODULE = showlease
LOCAL_MODULE_TAGS := debug
include $(BUILD_EXECUTABLE)

#include $(CLEAR_VARS)
#LOCAL_MODULE := dhcpcd.conf
#LOCAL_MODULE_CLASS := ETC
#LOCAL_MODULE_PATH := $(etc_dir)
#LOCAL_SRC_FILES := android.conf
#include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := dhcpcd-run-hooks
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_PATH := $(etc_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := 20-dns.conf
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(hooks_target)
LOCAL_SRC_FILES := $(hooks_dir)/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := 95-configured
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(hooks_target)
LOCAL_SRC_FILES := $(hooks_dir)/$(LOCAL_MODULE)
include $(BUILD_PREBUILT)

# Unit tests.
include $(CLEAR_VARS)
LOCAL_MODULE := dhcpcd_test
LOCAL_CFLAGS := -Wall -Werror -Wunused-parameter
LOCAL_SRC_FILES := dhcpcd_test.cpp dhcp.c common.c
LOCAL_CFLAGS := $(dhcpd_cflags)
LOCAL_MODULE_TAGS := eng tests
include $(BUILD_NATIVE_TEST)
