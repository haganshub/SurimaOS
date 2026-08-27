#!/bin/bash
#
# BLFS build: Pango-1.57.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./11-pango.sh [--force]
#
# Real dependencies now all satisfied: Fontconfig, FriBidi, GLib
# (required), Cairo, Xorg Libraries, gobject-introspection
# (recommended, have via GLib's build). No test suite run, some
# known test failures without extra fonts (Cantarell) we don't need.
#
# introspection=enabled forced explicitly: GTK3's build later needs
# Pango-1.0.gir, which requires Pango to have been built with
# introspection support. The default "auto" silently resolved to
# false even though gobject-introspection-1.0 was genuinely present
# and version-satisfied, forcing it explicitly fixed this.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-pango" "$1"

echo "=== Building Pango 1.57.0 ==="

cd /root/src
rm -rf pango-1.57.0
wget https://download.gnome.org/sources/pango/1.57/pango-1.57.0.tar.xz
tar xf pango-1.57.0.tar.xz
cd pango-1.57.0

mkdir build
cd build

meson setup --prefix=/usr \
      --buildtype=release \
      --wrap-mode=nofallback \
      -D introspection=enabled \
      ..
ninja

ninja install

mark_done "12-pango"
echo "=== Pango complete ==="
