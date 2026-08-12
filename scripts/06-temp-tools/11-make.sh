#!/bin/bash
#
# SurimaOS build: 6.12. Make-4.4.1
# Usage: ./11-make.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-make"

echo "=== Building Make 4.4.1 ==="

cd "$LFS/sources"
rm -rf make-4.4.1
tar xf make-4.4.1.tar.gz
cd make-4.4.1

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-make"
echo "=== Make complete ==="
