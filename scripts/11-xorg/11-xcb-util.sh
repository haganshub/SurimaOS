#!/bin/bash
#
# BLFS build: xcb-util-0.4.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./11-xcb-util.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xcb-util" "$1"

echo "=== Building xcb-util 0.4.1 ==="

cd /root/src
rm -rf xcb-util-0.4.1
wget https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz
tar xf xcb-util-0.4.1.tar.xz
cd xcb-util-0.4.1

./configure $XORG_CONFIG

make

make install

mark_done "11-xcb-util"
echo "=== xcb-util complete ==="
