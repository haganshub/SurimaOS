#!/bin/bash
#
# SurimaOS build: 6.13. Patch-2.8
# Usage: ./12-patch.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-patch"

echo "=== Building Patch 2.8 ==="

cd "$LFS/sources"
rm -rf patch-2.8
tar xf patch-2.8.tar.xz
cd patch-2.8

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-patch"
echo "=== Patch complete ==="
