#!/bin/bash
#
# SurimaOS build: 8.6. Zlib-1.3.2
# Run INSIDE chroot. Usage: ./04-zlib.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-zlib"

echo "=== Building Zlib 1.3.2 ==="

cd /sources
rm -rf zlib-1.3.2
tar xf zlib-1.3.2.tar.gz
cd zlib-1.3.2

time {
./configure --prefix=/usr

make

make check

make install
}

rm -fv /usr/lib/libz.a

mark_done "08-zlib"
echo "=== Zlib complete ==="
