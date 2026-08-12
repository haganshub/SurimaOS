#!/bin/bash
#
# SurimaOS build: 6.2. M4-1.4.21
# Usage: ./01-m4.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-m4"

echo "=== Building M4 1.4.21 ==="

cd "$LFS/sources"
rm -rf m4-1.4.21
tar xf m4-1.4.21.tar.xz
cd m4-1.4.21

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-m4"
echo "=== M4 complete ==="
