#!/bin/bash
#
# BLFS build: libxfce4windowing-4.20.5
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./23-libxfce4windowing.sh [--force]
#
# Real deps confirmed: GTK3, libwnck (both have). X11 support is
# fully functional via libwnck per upstream's own description,
# Wayland support is partial and optional, we don't want it anyway.
# --enable-x11/--disable-wayland required explicitly, configure
# errors with "At least one windowing backend must be enabled" if
# neither is specified, X11 doesn't default on.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxfce4windowing" "$1"

echo "=== Building libxfce4windowing 4.20.5 ==="

cd /root/src
rm -rf libxfce4windowing-4.20.5
wget https://archive.xfce.org/src/xfce/libxfce4windowing/4.20/libxfce4windowing-4.20.5.tar.bz2
tar xf libxfce4windowing-4.20.5.tar.bz2
cd libxfce4windowing-4.20.5

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --sysconfdir=/etc \
            --enable-x11 --disable-wayland \
            $INTROSPECTION_FLAG

make

make install

mark_done "12-libxfce4windowing"
echo "=== libxfce4windowing complete ==="
