#!/bin/bash
#
# BLFS build: libgudev-238
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./28-libgudev.sh [--force]
#
# Needed by thunar-volman. No test suite run, one known test
# (test-gudevdevice) fails with systemd-259.4+, which we have.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libgudev" "$1"

echo "=== Building libgudev 238 ==="

cd /root/src
rm -rf libgudev-238
wget https://download.gnome.org/sources/libgudev/238/libgudev-238.tar.xz
tar xf libgudev-238.tar.xz
cd libgudev-238

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "12-libgudev"
echo "=== libgudev complete ==="
