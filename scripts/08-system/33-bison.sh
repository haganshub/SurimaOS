#!/bin/bash
#
# SurimaOS build: 8.35. Bison-3.8.2 (final install)
# Run INSIDE chroot. Usage: ./33-bison.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-bison"

echo "=== Building Bison 3.8.2 (final) ==="

cd /sources
rm -rf bison-3.8.2
tar xf bison-3.8.2.tar.xz
cd bison-3.8.2

time {
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make

make check

make install
}

mark_done "08-bison"
echo "=== Bison complete ==="
