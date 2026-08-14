#!/bin/bash
#
# SurimaOS build: 8.60. Kmod-34.2
# Run INSIDE chroot. Usage: ./58-kmod.sh [--force]
#
# NOTE: first package in this project built with Meson/Ninja instead
# of the usual configure/make. Test suite requires raw (unsanitized)
# kernel headers, out of scope for LFS, skipped per the book.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-kmod"

echo "=== Building Kmod 34.2 ==="

cd /sources
rm -rf kmod-34.2
tar xf kmod-34.2.tar.xz
cd kmod-34.2

rm -rf build
mkdir -p build
cd       build

time {
meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false

ninja

ninja install
}

mark_done "08-kmod"
echo "=== Kmod complete ==="
