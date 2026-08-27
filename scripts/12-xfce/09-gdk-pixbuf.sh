#!/bin/bash
#
# BLFS build: gdk-pixbuf-2.44.5
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./09-gdk-pixbuf.sh [--force]
#
# DECISION: keeping the old deprecated built-in loaders (png, gif,
# jpeg, tiff) ENABLED instead of following the book's example, which
# disables all of them in favor of the newer glycin sandboxed loader
# system. glycin is a real dependency chain of its own (recommended,
# not required) that we're deliberately avoiding, same reasoning as
# skipping Vulkan/LLVM earlier. Without either glycin or these old
# loaders, gdk-pixbuf couldn't display PNG/JPEG images at all, a real
# problem for a desktop (icons, wallpapers, thumbnails).
#
# glycin explicitly disabled since we don't have it and don't plan to
# build it. man=false: same rst2man/docutils gap hit with GLib, this
# option defaults to true and needs the docutils Python module we
# don't have. Cosmetic docs, disabling rather than adding a new
# dependency.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-gdk-pixbuf" "$1"

echo "=== Building gdk-pixbuf 2.44.5 (old loaders enabled, no glycin) ==="

cd /root/src
rm -rf gdk-pixbuf-2.44.5
wget https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-2.44.5.tar.xz
tar xf gdk-pixbuf-2.44.5.tar.xz
cd gdk-pixbuf-2.44.5

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D png=enabled \
      -D gif=enabled \
      -D jpeg=enabled \
      -D tiff=enabled \
      -D thumbnailer=enabled \
      -D glycin=disabled \
      -D man=false \
      --wrap-mode=nofallback
ninja

ninja install

gdk-pixbuf-query-loaders --update-cache

mark_done "12-gdk-pixbuf"
echo "=== gdk-pixbuf complete ==="
