#!/bin/bash
#
# BLFS build: libevdev-1.13.6
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./49-libevdev.sh [--force]
#
# Real gap found post-reboot: display worked (Xorg/Mesa/GTK3/lightdm
# all rendering correctly) but mouse/keyboard input did nothing. We
# never built the Xorg Input Drivers chapter, xorg-libinput is listed
# as a RUNTIME dependency on Xorg-Server's own page, meaning it
# wasn't needed to build the server, only to actually use input.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libevdev" "$1"

echo "=== Building libevdev 1.13.6 ==="

cd /root/src
rm -rf libevdev-1.13.6
wget https://www.freedesktop.org/software/libevdev/libevdev-1.13.6.tar.xz
tar xf libevdev-1.13.6.tar.xz
cd libevdev-1.13.6

mkdir build
cd build

meson setup --prefix=/usr \
      --buildtype=release \
      -D documentation=disabled \
      -D tests=disabled \
      ..
ninja

ninja install

mark_done "12-libevdev"
echo "=== libevdev complete ==="
