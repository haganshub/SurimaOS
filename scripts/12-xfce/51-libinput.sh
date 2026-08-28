#!/bin/bash
#
# BLFS build: libinput-1.22.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./51-libinput.sh [--force]
#
# Real deps (libevdev, mtdev) both just built. No test suite run,
# the extensive suite needs /dev/uinput, Valgrind, and libunwind, not
# worth the setup for a library we just need working, not exhaustively
# tested.
#
# libwacom=false: defaults to true and the build hard-fails without
# it (a whole tablet-identification library we don't need for a
# laptop's built-in trackpad/keyboard). debug-gui=false: also
# defaults on and needs a GTK3 event-viewer tool we don't need.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libinput" "$1"

echo "=== Building libinput 1.22.1 ==="

cd /root/src
rm -rf libinput-1.22.1
wget https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.22.1/libinput-1.22.1.tar.gz
tar xf libinput-1.22.1.tar.gz
cd libinput-1.22.1

mkdir build
cd build

meson setup --prefix=/usr \
      --buildtype=release \
      -D tests=false \
      -D documentation=false \
      -D libwacom=false \
      -D debug-gui=false \
      ..
ninja

ninja install

mark_done "12-libinput"
echo "=== libinput complete ==="
