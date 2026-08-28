#!/bin/bash
#
# BLFS build: tumbler-4.20.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./30-tumbler.sh [--force]
#
# Only one real required dep (GLib, have). Everything else in the
# book's list is an optional per-filetype thumbnailer plugin. We
# already have gdk-pixbuf, libjpeg-turbo, libpng, FreeType from
# earlier in this chain, so those specific plugins should just
# auto-enable.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-tumbler" "$1"

echo "=== Building tumbler 4.20.1 ==="

cd /root/src
rm -rf tumbler-4.20.1
wget https://archive.xfce.org/src/xfce/tumbler/4.20/tumbler-4.20.1.tar.bz2
tar xf tumbler-4.20.1.tar.bz2
cd tumbler-4.20.1

./configure --prefix=/usr --sysconfdir=/etc
make

make install

mark_done "12-tumbler"
echo "=== tumbler complete ==="
