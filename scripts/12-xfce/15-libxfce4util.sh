#!/bin/bash
#
# BLFS build: libxfce4util-4.20.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./15-libxfce4util.sh [--force]
#
# First actual XFCE component (Chapter 35). Simple autotools build,
# no test suite. Required dep (GLib with GObject Introspection)
# already satisfied from GLib's own multi-stage build earlier.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxfce4util" "$1"

echo "=== Building libxfce4util 4.20.1 ==="

cd /root/src
rm -rf libxfce4util-4.20.1
wget https://archive.xfce.org/src/xfce/libxfce4util/4.20/libxfce4util-4.20.1.tar.bz2
tar xf libxfce4util-4.20.1.tar.bz2
cd libxfce4util-4.20.1

./configure --prefix=/usr
make

make install

mark_done "12-libxfce4util"
echo "=== libxfce4util complete ==="
