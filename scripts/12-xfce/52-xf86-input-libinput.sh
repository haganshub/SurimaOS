#!/bin/bash
#
# BLFS build: xf86-input-libinput-1.2.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./52-xf86-input-libinput.sh [--force]
#
# THE ACTUAL MISSING PIECE. This is the real Xorg input driver module
# that lets the X server read from libinput at all. Everything before
# this script (libevdev, mtdev, libinput) was just building up to
# this. Real dep (Xorg-Server) already satisfied.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xf86-input-libinput" "$1"

echo "=== Building xf86-input-libinput 1.2.1 ==="

cd /root/src
rm -rf xf86-input-libinput-1.2.1
wget https://www.x.org/pub/individual/driver/xf86-input-libinput-1.2.1.tar.xz
tar xf xf86-input-libinput-1.2.1.tar.xz
cd xf86-input-libinput-1.2.1

./configure $XORG_CONFIG
make

make install

mark_done "12-xf86-input-libinput"
echo "=== xf86-input-libinput complete ==="
echo ""
echo "=== That's the real missing piece. Restart lightdm and mouse/"
echo "=== keyboard input should finally work: ==="
echo "===     systemctl restart lightdm ==="
