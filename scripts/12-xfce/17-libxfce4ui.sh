#!/bin/bash
#
# BLFS build: libxfce4ui-4.20.2
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./17-libxfce4ui.sh [--force]
#
# startup-notification skipped, only "Recommended" (cosmetic busy
# cursor on app launch), not required. Add later if something
# downstream genuinely needs it.
#
# --enable-introspection=no: direct consequence of disabling GTK3's
# own introspection earlier (the fix for the HarfBuzz .gir dead end).
# This package tries to build its own .gir referencing Gtk-3.0.gir,
# which doesn't exist now. Since every remaining XFCE component is
# built the same way, treating this as a standing rule going forward
# rather than waiting for each one to fail individually.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxfce4ui" "$1"

echo "=== Building libxfce4ui 4.20.2 ==="

cd /root/src
rm -rf libxfce4ui-4.20.2
wget https://archive.xfce.org/src/xfce/libxfce4ui/4.20/libxfce4ui-4.20.2.tar.bz2
tar xf libxfce4ui-4.20.2.tar.bz2
cd libxfce4ui-4.20.2

./configure --prefix=/usr --sysconfdir=/etc --enable-introspection=no
make

make install

mark_done "12-libxfce4ui"
echo "=== libxfce4ui complete ==="
