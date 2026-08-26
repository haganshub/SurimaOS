#!/bin/bash
#
# BLFS build: libxcvt-0.1.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./10-libxcvt.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libxcvt" "$1"

echo "=== Building libxcvt 0.1.3 ==="

cd /root/src
rm -rf libxcvt-0.1.3
wget https://www.x.org/pub/individual/lib/libxcvt-0.1.3.tar.xz
tar xf libxcvt-0.1.3.tar.xz
cd libxcvt-0.1.3

mkdir build
cd build

meson setup --prefix=$XORG_PREFIX --buildtype=release ..
ninja

ninja install

mark_done "11-libxcvt"
echo "=== libxcvt complete ==="
