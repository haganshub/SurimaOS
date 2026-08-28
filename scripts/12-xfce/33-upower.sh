#!/bin/bash
#
# BLFS build: UPower-1.91.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./33-upower.sh [--force]
#
# Needed by xfce4-power-manager. Deliberately NOT passing
# -D systemdsystemunitdir=no like the book's generic example does,
# that flag exists to strip systemd integration for non-systemd
# setups, we have real systemd and want UPower to actually start
# automatically via it.
#
# No test suite run, needs a real local GUI session with dbus-launch.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-upower" "$1"

echo "=== Building UPower 1.91.1 ==="

cd /root/src
rm -rf upower-v1.91.1
wget https://gitlab.freedesktop.org/upower/upower/-/archive/v1.91.1/upower-v1.91.1.tar.bz2
tar xf upower-v1.91.1.tar.bz2
cd upower-v1.91.1

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D gtk-doc=false \
      -D man=false \
      -D udevrulesdir=/usr/lib/udev/rules.d
ninja

ninja install

mark_done "12-upower"
echo "=== UPower complete ==="
