#!/bin/bash
#
# BLFS build: libxml2-2.15.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./23-libxml2.sh [--force]
#
# icu left disabled: it's an optional feature needing a whole separate
# large package (ICU) we don't need for anything else right now.
# SPIRV-LLVM-Translator doesn't require it.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libxml2" "$1"

echo "=== Building libxml2 2.15.1 ==="

cd /root/src
rm -rf libxml2-2.15.1
wget https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
tar xf libxml2-2.15.1.tar.xz
cd libxml2-2.15.1

mkdir build
cd build

meson setup --prefix=/usr        \
            --buildtype=release  \
            -D history=enabled   \
            ..
ninja

ninja install

sed "s/--static/--shared/" -i /usr/bin/xml2-config

mark_done "11-libxml2"
echo "=== libxml2 complete ==="
