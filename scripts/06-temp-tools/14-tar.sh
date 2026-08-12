#!/bin/bash
#
# SurimaOS build: 6.15. Tar-1.35
# Usage: ./14-tar.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-tar"

echo "=== Building Tar 1.35 ==="

cd "$LFS/sources"
rm -rf tar-1.35
tar xf tar-1.35.tar.xz
cd tar-1.35

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-tar"
echo "=== Tar complete ==="
