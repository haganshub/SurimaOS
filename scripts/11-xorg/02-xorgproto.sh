#!/bin/bash
#
# BLFS build: xorgproto-2025.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./02-xorgproto.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xorgproto" "$1"

echo "=== Building xorgproto 2025.1 ==="

cd /root/src
rm -rf xorgproto-2025.1
wget https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2025.1.tar.xz
tar xf xorgproto-2025.1.tar.xz
cd xorgproto-2025.1

mkdir build
cd build

meson setup --prefix=$XORG_PREFIX ..
ninja

ninja install
mv -v $XORG_PREFIX/share/doc/xorgproto{,-2025.1}

mark_done "11-xorgproto"
echo "=== xorgproto complete ==="
