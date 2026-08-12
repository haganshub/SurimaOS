#!/bin/bash
#
# SurimaOS build: 6.11. Gzip-1.14
# Usage: ./10-gzip.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-gzip"

echo "=== Building Gzip 1.14 ==="

cd "$LFS/sources"
rm -rf gzip-1.14
tar xf gzip-1.14.tar.xz
cd gzip-1.14

time {
./configure --prefix=/usr --host=$LFS_TGT

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-gzip"
echo "=== Gzip complete ==="
