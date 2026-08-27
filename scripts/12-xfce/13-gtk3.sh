#!/bin/bash
#
# BLFS build: GTK-3.24.51
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./13-gtk3.sh [--force]
#
# The actual top of the GTK3 chain we've been building all session.
# Real required deps (GLib, Cairo, Pango, gdk-pixbuf, at-spi2-core,
# FriBidi, Xorg Libraries) are all satisfied. Recommended-but-skipped:
# ISO Codes, libxkbcommon, Wayland/wayland-protocols (we don't want
# Wayland at all, XFCE is X11-only, confirmed earlier this project).
#
# man=false set proactively this time: the same rst2man/docutils gap
# hit twice already (GLib, gdk-pixbuf) would hit again here with the
# book's own example command (man=true). No reason to wait for a
# predictable failure.
#
# wayland_backend=false: confirmed real option name from
# meson_options.txt after GTK3's build failed looking for
# wayland-client, which we don't have and don't want (X11-only,
# confirmed earlier this project).
#
# introspection=false: GTK3's own build needs Gdk-3.0.gir, which
# needs Pango-1.0.gir, which needs HarfBuzz's own .gir, and HarfBuzz's
# build system genuinely has zero introspection support wired in at
# all (confirmed, no option exists anywhere in its meson files). This
# is a real dead end going the "enable everything" direction. XFCE is
# a native C/GTK desktop, not something needing Python/JS language
# bindings, so introspection metadata isn't actually required for it
# to function. Disabling it here avoids the whole cascading chain.
#
# No test suite run, needs a real graphical session and
# gschemas.compiled to be current, not worth the setup for this.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-gtk3" "$1"

echo "=== Building GTK3 3.24.51 ==="

cd /root/src
rm -rf gtk-3.24.51
wget https://download.gnome.org/sources/gtk/3.24/gtk-3.24.51.tar.xz
tar xf gtk-3.24.51.tar.xz
cd gtk-3.24.51

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D man=false \
      -D introspection=false \
      -D wayland_backend=false \
      -D broadway_backend=true
ninja

ninja install

echo "=== Compiling glib schemas for GTK3 ==="
glib-compile-schemas /usr/share/glib-2.0/schemas

mark_done "12-gtk3"
echo "=== GTK3 complete ==="
echo ""
echo "=== That's the whole GTK3 chain closed. Ready for XFCE's own"
echo "=== component stack. ==="
