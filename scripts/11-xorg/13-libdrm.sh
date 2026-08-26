#!/bin/bash
#
# BLFS build: Libdrm-2.4.131
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./13-libdrm.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libdrm" "$1"

echo "=== Building Libdrm 2.4.131 ==="

cd /root/src
rm -rf libdrm-2.4.131
wget https://dri.freedesktop.org/libdrm/libdrm-2.4.131.tar.xz
tar xf libdrm-2.4.131.tar.xz
cd libdrm-2.4.131

mkdir build
cd build

meson setup --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D udev=true          \
            -D valgrind=disabled  \
            ..
ninja

ninja install

mark_done "11-libdrm"
echo "=== Libdrm complete ==="
