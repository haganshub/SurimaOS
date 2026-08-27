#!/bin/bash
#
# BLFS build: libjpeg-turbo-3.1.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./07-libjpeg-turbo.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libjpeg-turbo" "$1"

echo "=== Building libjpeg-turbo 3.1.3 ==="

cd /root/src
rm -rf libjpeg-turbo-3.1.3
wget https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.3/libjpeg-turbo-3.1.3.tar.gz
tar xf libjpeg-turbo-3.1.3.tar.gz
cd libjpeg-turbo-3.1.3

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=RELEASE         \
      -D ENABLE_STATIC=FALSE              \
      -D CMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      -D CMAKE_SKIP_INSTALL_RPATH=ON      \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-3.1.3 \
      ..
make

make install

mark_done "12-libjpeg-turbo"
echo "=== libjpeg-turbo complete ==="
