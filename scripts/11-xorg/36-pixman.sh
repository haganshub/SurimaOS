#!/bin/bash
#
# BLFS build: Pixman-0.46.4
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./36-pixman.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-pixman" "$1"

echo "=== Building Pixman 0.46.4 ==="

cd /root/src
rm -rf pixman-0.46.4
wget https://www.cairographics.org/releases/pixman-0.46.4.tar.gz
tar xf pixman-0.46.4.tar.gz
cd pixman-0.46.4

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "11-pixman"
echo "=== Pixman complete ==="
