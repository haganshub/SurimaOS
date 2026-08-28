#!/bin/bash
#
# BLFS build: libdisplay-info-0.3.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./24-libdisplay-info.sh [--force]
#
# Genuine hard requirement for libxfce4windowing's X11 backend,
# despite not showing up anywhere obvious until configure demanded it
# directly. Simple meson build, no required deps.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libdisplay-info" "$1"

echo "=== Building libdisplay-info 0.3.0 ==="

cd /root/src
rm -rf libdisplay-info-0.3.0
wget https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/0.3.0/downloads/libdisplay-info-0.3.0.tar.xz
tar xf libdisplay-info-0.3.0.tar.xz
cd libdisplay-info-0.3.0

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "12-libdisplay-info"
echo "=== libdisplay-info complete ==="
