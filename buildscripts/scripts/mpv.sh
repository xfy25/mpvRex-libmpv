#!/bin/bash -e

. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

# Android provides Vulkan, but no pkgconfig file
# you can double-check the version in vulkan_core.h (-> VK_HEADER_VERSION)
mkdir -p "$prefix_dir"/lib/pkgconfig
cat >"$prefix_dir"/lib/pkgconfig/vulkan.pc <<"END"
Name: Vulkan
Description:
Version: 1.3.275
Libs: -lvulkan
Cflags:
END

unset CC CXX # meson wants these unset

for p in "$DIR"/patches/*.patch; do
	[ -e "$p" ] || continue
	if patch -p1 -N --dry-run --forward < "$p" >/dev/null 2>&1; then
		echo "Applying $(basename "$p")"
		patch -p1 --forward < "$p"
	elif patch -p1 -N --dry-run --reverse < "$p" >/dev/null 2>&1; then
		echo "$(basename "$p") already applied"
	else
		echo >&2 "ERROR: $(basename "$p") does not apply, refusing to build an unpatched libmpv"
		exit 1
	fi
done

meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
	--default-library shared \
	-Diconv=disabled -Dlua=enabled -Dvulkan=enabled \
	-Dlibmpv=true -Dcplayer=false \
	-Dmanpage-build=disabled

ninja -C $build -j$cores
if [ -f $build/libmpv.a ]; then
	echo >&2 "Meson fucked up, forcing rebuild."
	$0 clean
	exec $0 build
fi
DESTDIR="$prefix_dir" ninja -C $build install
