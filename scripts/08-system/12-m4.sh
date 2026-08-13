#!/bin/bash
#
# SurimaOS build: 8.14. M4-1.4.21 (final install)
# Run INSIDE chroot. Usage: ./12-m4.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-m4"

echo "=== Building M4 1.4.21 (final) ==="

cd /sources
rm -rf m4-1.4.21
tar xf m4-1.4.21.tar.xz
cd m4-1.4.21

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-m4"
echo "=== M4 complete ==="
