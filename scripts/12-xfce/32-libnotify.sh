#!/bin/bash
#
# BLFS build: libnotify-0.8.8
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./32-libnotify.sh [--force]
#
# Needed by xfce4-power-manager. Note: for actual desktop
# notifications to work at runtime, a notification daemon is also
# needed (xfce4-notifyd is the natural XFCE choice), not required for
# this library to build though, just to be functional later.
#
# tests=false: the default (true) pulls in a GTK4 dependency we don't
# have, for a demo notification test app, not needed for the library
# itself. introspection=disabled per this project's standing rule.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libnotify" "$1"

echo "=== Building libnotify 0.8.8 ==="

cd /root/src
rm -rf libnotify-0.8.8
wget https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.8.tar.xz
tar xf libnotify-0.8.8.tar.xz
cd libnotify-0.8.8

mkdir build
cd build

meson setup --prefix=/usr \
      --buildtype=release \
      -D gtk_doc=false \
      -D man=false \
      -D tests=false \
      -D introspection=disabled \
      ..
ninja

ninja install

if [ -e /usr/share/doc/libnotify ]; then
  rm -rf /usr/share/doc/libnotify-0.8.8
  mv -v /usr/share/doc/libnotify{,-0.8.8}
fi

mark_done "12-libnotify"
echo "=== libnotify complete ==="
