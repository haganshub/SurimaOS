#!/bin/bash
#
# BLFS build: GLib-2.86.4 (with GObject Introspection)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./04-glib.sh [--force]
#
# Genuinely multi-stage: build GLib without introspection, install,
# build GObject Introspection separately against that install, install
# it, then reconfigure GLib WITH introspection enabled and rebuild.
# No test suite run (the book's own test instructions require careful
# non-root handling and log-file permission tweaks, skipping for a
# non-critical library).
#
# man-pages=disabled: the book's example uses man-pages=enabled, but
# that needs rst2man from the docutils Python module, which is only
# "Recommended," not required, and we don't have it. Man pages are
# cosmetic here, disabling rather than adding a whole new dependency.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-glib" "$1"

echo "=== Building GLib 2.86.4 + GObject Introspection ==="

cd /root/src
rm -rf glib-2.86.4 gobject-introspection-1.86.0

wget https://download.gnome.org/sources/glib/2.86/glib-2.86.4.tar.xz
wget https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/13.0/glib-2.86.4-upstream_fixes-1.patch

tar xf glib-2.86.4.tar.xz
cd glib-2.86.4

echo "=== Applying required upstream fix patch (memory corruption on glibc-2.43) ==="
patch -Np1 -i ../glib-2.86.4-upstream_fixes-1.patch

if [ -e /usr/include/glib-2.0 ]; then
  rm -rf /usr/include/glib-2.0.old
  mv -vf /usr/include/glib-2.0{,.old}
fi

mkdir build
cd build

echo "=== Stage 1: building GLib without introspection ==="
meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D introspection=disabled \
      -D glib_debug=disabled \
      -D man-pages=disabled \
      -D sysprof=disabled
ninja

echo "=== Installing GLib (first pass, needed before building Introspection) ==="
ninja install

echo "=== Stage 2: building GObject Introspection against this GLib ==="
tar xf ../../gobject-introspection-1.86.0.tar.xz
meson setup gobject-introspection-1.86.0 gi-build \
      --prefix=/usr --buildtype=release
ninja -C gi-build

echo "=== Installing GObject Introspection ==="
ninja -C gi-build install

echo "=== Stage 3: reconfiguring and rebuilding GLib WITH introspection enabled ==="
meson configure -D introspection=enabled
ninja

echo "=== Installing GLib (final pass, now with introspection data) ==="
ninja install

mark_done "12-glib"
echo "=== GLib + GObject Introspection complete ==="
