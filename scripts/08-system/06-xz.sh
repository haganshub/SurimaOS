#!/bin/bash
#
# SurimaOS build: 8.8. Xz-5.8.2 (final install)
# Run INSIDE chroot. Usage: ./06-xz.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-xz"

echo "=== Building Xz 5.8.2 (final) ==="

cd /sources
rm -rf xz-5.8.2
tar xf xz-5.8.2.tar.xz
cd xz-5.8.2

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.2

make

make check

make install
}

mark_done "08-xz"
echo "=== Xz complete ==="
