#!/bin/bash
#
# SurimaOS build: 6.14. Sed-4.9
# Usage: ./13-sed.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-sed"

echo "=== Building Sed 4.9 ==="

cd "$LFS/sources"
rm -rf sed-4.9
tar xf sed-4.9.tar.xz
cd sed-4.9

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-sed"
echo "=== Sed complete ==="
