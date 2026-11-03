#!/bin/bash -e

## Dependency versions
# Make sure to keep v_ndk and v_ndk_n in sync, both are listed on the NDK download page

v_sdk=11076708_latest
v_ndk=r29
v_ndk_n=29.0.14206865
v_sdk_platform=35
v_sdk_build_tools=35.0.0

v_lua=5.2.4
v_unibreak=7.0
v_harfbuzz=14.2.1
v_fribidi=1.0.16
v_freetype=2.14.3
v_mbedtls=3.6.5


## Dependency tree

dep_mbedtls=()
dep_dav1d=()
dep_ffmpeg=(mbedtls dav1d)
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_unibreak=()
dep_libass=(freetype2 fribidi harfbuzz unibreak)
dep_lua=()
dep_shaderc=()
dep_libplacebo=(shaderc)
dep_mpv=(ffmpeg libass lua libplacebo)
dep_mpv_android=(mpv)


## for CI workflow

# pinned ffmpeg revision
v_ci_ffmpeg=n8.1.2

# mpv is pinned to the last master commit before the v0.0.9 libmpv build
# (2026-08-04), i.e. what REX 4.5.0 actually shipped. Later commits raise the
# Vulkan requirement to >= 1.4.309 and fail to configure: the Android NDK r29
# still ships Vulkan 1.3.275 headers.
v_mpv_pin=1d15686142fd5d53c954aab7526cedab05ef9dc3

# filename used to uniquely identify a build prefix
ci_tarball="prefix-ndk-${v_ndk}-lua-${v_lua}-unibreak-${v_unibreak}-harfbuzz-${v_harfbuzz}-fribidi-${v_fribidi}-freetype-${v_freetype}-mbedtls-${v_mbedtls}-ffmpeg-${v_ci_ffmpeg}.tgz"
