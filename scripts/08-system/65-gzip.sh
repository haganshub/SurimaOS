#!/bin/bash
#
# SurimaOS build: 8.67. Gzip-1.14 (final install)
# Run INSIDE chroot. Usage: ./65-gzip.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gzip"

echo "=== Building Gzip 1.14 (final) ==="

cd /sources
rm -rf gzip-1.14
tar xf gzip-1.14.tar.xz
cd gzip-1.14

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-gzip"
echo "=== Gzip complete ==="
