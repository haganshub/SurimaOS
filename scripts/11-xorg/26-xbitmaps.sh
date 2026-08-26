#!/bin/bash
#
# BLFS build: xbitmaps-1.1.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./26-xbitmaps.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xbitmaps" "$1"

echo "=== Building xbitmaps 1.1.3 ==="

cd /root/src
rm -rf xbitmaps-1.1.3
wget https://www.x.org/pub/individual/data/xbitmaps-1.1.3.tar.xz
tar xf xbitmaps-1.1.3.tar.xz
cd xbitmaps-1.1.3

./configure $XORG_CONFIG

make install

mark_done "11-xbitmaps"
echo "=== xbitmaps complete ==="
