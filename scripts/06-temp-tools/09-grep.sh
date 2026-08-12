#!/bin/bash
#
# SurimaOS build: 6.10. Grep-3.12
# Usage: ./09-grep.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-grep"

echo "=== Building Grep 3.12 ==="

cd "$LFS/sources"
rm -rf grep-3.12
tar xf grep-3.12.tar.xz
cd grep-3.12

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-grep"
echo "=== Grep complete ==="
