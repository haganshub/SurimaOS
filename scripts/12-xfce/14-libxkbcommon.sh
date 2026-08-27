#!/bin/bash
#
# BLFS build: libxkbcommon-1.13.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./14-libxkbcommon.sh [--force]
#
# Turned out to be a genuine hard requirement for GTK3 despite being
# listed as "Recommended" in the book's prose, same pattern as libclc
# earlier this project. GTK3's build failed with a clean "Dependency
# xkbcommon not found" error, no guessing needed this time.
#
# enable-docs=false: we don't have Doxygen, and don't need the docs.
# enable-wayland=false: we don't want Wayland support at all (XFCE is
# X11-only, confirmed earlier this project), and the xkbcli Wayland
# tools need wayland-client/wayland-protocols we don't have.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxkbcommon" "$1"

echo "=== Building libxkbcommon 1.13.1 ==="

cd /root/src
rm -rf libxkbcommon-1.13.1
wget https://github.com/lfs-book/libxkbcommon/archive/v1.13.1/libxkbcommon-1.13.1.tar.gz
tar xf libxkbcommon-1.13.1.tar.gz
cd libxkbcommon-1.13.1

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D enable-docs=false \
      -D enable-wayland=false
ninja

ninja install

mark_done "12-libxkbcommon"
echo "=== libxkbcommon complete ==="
