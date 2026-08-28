#!/bin/bash
#
# BLFS build: libwnck-43.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./20-libwnck.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libwnck" "$1"

echo "=== Building libwnck 43.3 ==="

cd /root/src
rm -rf libwnck-43.3
wget https://download.gnome.org/sources/libwnck/43/libwnck-43.3.tar.xz
tar xf libwnck-43.3.tar.xz
cd libwnck-43.3

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release -D introspection=disabled ..
ninja

ninja install

mark_done "12-libwnck"
echo "=== libwnck complete ==="
