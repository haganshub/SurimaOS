#!/bin/bash
#
# BLFS build: libtiff-4.7.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./08-libtiff.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libtiff" "$1"

echo "=== Building libtiff 4.7.1 ==="

cd /root/src
rm -rf tiff-4.7.1
wget https://download.osgeo.org/libtiff/tiff-4.7.1.tar.gz
tar xf tiff-4.7.1.tar.gz
cd tiff-4.7.1

mkdir -p libtiff-build
cd libtiff-build

cmake -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.7.1 \
      -D CMAKE_INSTALL_PREFIX=/usr -G Ninja ..
ninja

ninja install

mark_done "12-libtiff"
echo "=== libtiff complete ==="
