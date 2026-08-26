#!/bin/bash
#
# BLFS build: libpng-1.6.55
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./27-libpng.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libpng" "$1"

echo "=== Building libpng 1.6.55 ==="

cd /root/src
rm -rf libpng-1.6.55
wget https://downloads.sourceforge.net/libpng/libpng-1.6.55.tar.xz
tar xf libpng-1.6.55.tar.xz
cd libpng-1.6.55

LIBS=-lpthread ./configure --prefix=/usr --disable-static

make

set +e
make check
set -e

make install
mkdir -v /usr/share/doc/libpng-1.6.55
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.55

mark_done "11-libpng"
echo "=== libpng complete ==="
