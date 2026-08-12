#!/bin/bash
#
# SurimaOS build: 6.9. Gawk-5.3.2
# Usage: ./08-gawk.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-gawk"

echo "=== Building Gawk 5.3.2 ==="

cd "$LFS/sources"
rm -rf gawk-5.3.2
tar xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-gawk"
echo "=== Gawk complete ==="
