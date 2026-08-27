#!/bin/bash
#
# BLFS build: Cairo-1.18.4
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./01-cairo.sh [--force]
#
# No required deps beyond what we already have (Fontconfig, FreeType,
# Pixman, libpng). Real note from the book: there's a circular
# dependency between Cairo and HarfBuzz. This is Cairo's FIRST pass,
# built before HarfBuzz exists. Once HarfBuzz is built later in this
# chain, Cairo needs a SECOND rebuild pass to get full Pango support.
# Don't forget that second pass, it's a real, documented requirement,
# not optional cleanup.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-cairo" "$1"

echo "=== Building Cairo 1.18.4 (pass 1, before HarfBuzz exists) ==="

cd /root/src
rm -rf cairo-1.18.4
wget https://www.cairographics.org/releases/cairo-1.18.4.tar.xz
tar xf cairo-1.18.4.tar.xz
cd cairo-1.18.4

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "12-cairo"
echo "=== Cairo (pass 1) complete ==="
echo "=== REMINDER: rebuild Cairo again after HarfBuzz is built. ==="
