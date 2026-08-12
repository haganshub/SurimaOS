#!/bin/bash
#
# SurimaOS build: 5.2. Binutils-2.46.0 - Pass 1
# Usage: ./01-binutils-pass1.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "01-binutils-pass1"

echo "=== Building Binutils 2.46.0 (Pass 1) ==="

cd "$LFS/sources"
tar xf binutils-2.46.0.tar.xz
cd binutils-2.46.0
rm -rf build
mkdir -v build
cd build

time {
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make -j$JOBS

make install
}

mark_done "01-binutils-pass1"
echo "=== Binutils Pass 1 complete ==="
