#!/bin/bash
#
# SurimaOS build: 8.38. Libtool-2.5.4
# Run INSIDE chroot. Usage: ./36-libtool.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libtool"

echo "=== Building Libtool 2.5.4 ==="

cd /sources
rm -rf libtool-2.5.4
tar xf libtool-2.5.4.tar.xz
cd libtool-2.5.4

time {
./configure --prefix=/usr

make

make check

make install
}

rm -fv /usr/lib/libltdl.a

mark_done "08-libtool"
echo "=== Libtool complete ==="
