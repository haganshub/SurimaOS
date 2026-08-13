#!/bin/bash
#
# SurimaOS build: 6.17. Binutils-2.46.0 - Pass 2
# Usage: ./16-binutils-pass2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-binutils-pass2"

echo "=== Building Binutils 2.46.0 (Pass 2) ==="

cd "$LFS/sources"
rm -rf binutils-2.46.0
tar xf binutils-2.46.0.tar.xz
cd binutils-2.46.0

# Work around a libtool inconsistency in the shipped libiberty/zlib
# copies that could otherwise cause binaries to mistakenly link
# against host-distro libraries.
sed '6031s/$add_dir//' -i ltmain.sh

rm -rf build
mkdir -v build
cd       build

time {
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls               \
    --enable-shared             \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

make -j$JOBS

make DESTDIR=$LFS install
}

# Libtool archive files and static libraries are harmful for
# cross-compilation at this stage, remove them.
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

mark_done "06-binutils-pass2"
echo "=== Binutils Pass 2 complete ==="
