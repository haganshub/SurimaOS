#!/bin/bash
#
# BLFS build: libepoxy-1.5.10
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./37-libepoxy.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libepoxy" "$1"

echo "=== Building libepoxy 1.5.10 ==="

cd /root/src
rm -rf libepoxy-1.5.10
wget https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.10.tar.xz
tar xf libepoxy-1.5.10.tar.xz
cd libepoxy-1.5.10

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "11-libepoxy"
echo "=== libepoxy complete ==="
