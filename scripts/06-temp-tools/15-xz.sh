#!/bin/bash
#
# SurimaOS build: 6.16. Xz-5.8.2
# Usage: ./15-xz.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-xz"

echo "=== Building Xz 5.8.2 ==="

cd "$LFS/sources"
rm -rf xz-5.8.2
tar xf xz-5.8.2.tar.xz
cd xz-5.8.2

time {
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.2

make -j$JOBS

make DESTDIR=$LFS install
}

rm -v $LFS/usr/lib/liblzma.la

mark_done "06-xz"
echo "=== Xz complete ==="
