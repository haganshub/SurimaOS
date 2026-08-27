#!/bin/bash
#
# BLFS build: at-spi2-core-2.58.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./12-at-spi2-core.sh [--force]
#
# NOTE: this is where ATK actually lives in current BLFS. There's no
# standalone ATK page anymore, GNOME merged its implementation into
# GTK3 years ago, and this package now installs the atk-1.0 headers
# directly (confirmed via the real book's table of contents, no bare
# ATK entry exists between Atkmm and at-spi2-core). Skipped hunting
# for a nonexistent standalone ATK package.
#
# No test suite run, needs dbus-run-session and a graphical
# environment we don't have yet.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-at-spi2-core" "$1"

echo "=== Building at-spi2-core 2.58.3 ==="

cd /root/src
rm -rf at-spi2-core-2.58.3
wget https://download.gnome.org/sources/at-spi2-core/2.58/at-spi2-core-2.58.3.tar.xz
tar xf at-spi2-core-2.58.3.tar.xz
cd at-spi2-core-2.58.3

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D gtk2_atk_adaptor=false
ninja

ninja install

mark_done "12-at-spi2-core"
echo "=== at-spi2-core complete ==="
