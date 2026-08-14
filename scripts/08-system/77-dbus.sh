#!/bin/bash
#
# SurimaOS build: 8.79. D-Bus-1.16.2
# Run INSIDE chroot. Usage: ./77-dbus.sh [--force]
#
# NOTE: many tests are disabled, require packages outside LFS scope.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-dbus"

echo "=== Building D-Bus 1.16.2 ==="

cd /sources
rm -rf dbus-1.16.2
tar xf dbus-1.16.2.tar.xz
cd dbus-1.16.2

rm -rf build
mkdir build
cd    build

time {
meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..

ninja

ninja test

ninja install
}

ln -sfv /etc/machine-id /var/lib/dbus

mark_done "08-dbus"
echo "=== D-Bus complete ==="
