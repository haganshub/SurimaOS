#!/bin/bash
#
# SurimaOS build: 6.8. Findutils-4.10.0
# Usage: ./07-findutils.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-findutils"

echo "=== Building Findutils 4.10.0 ==="

cd "$LFS/sources"
rm -rf findutils-4.10.0
tar xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

time {
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-findutils"
echo "=== Findutils complete ==="
