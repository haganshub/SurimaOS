#!/bin/bash
#
# BLFS build: Cairo-1.18.4 (pass 2, rebuild now that HarfBuzz exists)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./03-cairo-rebuild.sh [--force]
#
# Closes the circular dependency flagged in 01-cairo.sh. This build
# should now detect HarfBuzz and produce a Cairo that Pango can
# actually use correctly.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-cairo-rebuild" "$1"

echo "=== Rebuilding Cairo 1.18.4 (pass 2, with HarfBuzz present) ==="

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

mark_done "12-cairo-rebuild"
echo "=== Cairo (pass 2, with HarfBuzz) complete ==="
