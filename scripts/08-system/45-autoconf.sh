#!/bin/bash
#
# SurimaOS build: 8.47. Autoconf-2.72
# Run INSIDE chroot. Usage: ./45-autoconf.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-autoconf"

echo "=== Building Autoconf 2.72 ==="

cd /sources
rm -rf autoconf-2.72
tar xf autoconf-2.72.tar.xz
cd autoconf-2.72

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-autoconf"
echo "=== Autoconf complete ==="
