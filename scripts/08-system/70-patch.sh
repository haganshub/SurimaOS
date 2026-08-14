#!/bin/bash
#
# SurimaOS build: 8.72. Patch-2.8 (final install)
# Run INSIDE chroot. Usage: ./70-patch.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-patch"

echo "=== Building Patch 2.8 (final) ==="

cd /sources
rm -rf patch-2.8
tar xf patch-2.8.tar.xz
cd patch-2.8

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-patch"
echo "=== Patch complete ==="
