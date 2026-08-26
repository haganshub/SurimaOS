#!/bin/bash
#
# BLFS build: CMake-4.2.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./17-cmake.sh [--force]
#
# NOTE: --system-libs wants curl, libarchive, libuv, and nghttp2 all
# present. We have curl and libarchive already (Chapter 6 in this
# project's package manager work), but not libuv or nghttp2, so those
# two get --no-system-* to fall back to CMake's bundled copies.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-cmake" "$1"

echo "=== Building CMake 4.2.3 (this will take a while) ==="

cd /root/src
rm -rf cmake-4.2.3
wget https://cmake.org/files/v4.2/cmake-4.2.3.tar.gz
tar xf cmake-4.2.3.tar.gz
cd cmake-4.2.3

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

time {
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --no-system-libuv    \
            --no-system-nghttp2  \
            --docdir=/share/doc/cmake-4.2.3

make
}

make install

mark_done "11-cmake"
echo "=== CMake complete ==="
