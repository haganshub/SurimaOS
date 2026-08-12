#!/bin/bash
#
# SurimaOS build: 6.7. File-5.46
# Usage: ./06-file.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-file"

echo "=== Building File 5.46 ==="

cd "$LFS/sources"
rm -rf file-5.46
tar xf file-5.46.tar.gz
cd file-5.46

# Build a temporary host-side copy of 'file' first, its version has
# to match the one we're installing, to create the signature file.
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

time {
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install
}

rm -v $LFS/usr/lib/libmagic.la

mark_done "06-file"
echo "=== File complete ==="
