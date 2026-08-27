#!/bin/bash
#
# BLFS build: FriBidi-1.0.16
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./10-fribidi.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-fribidi" "$1"

echo "=== Building FriBidi 1.0.16 ==="

cd /root/src
rm -rf fribidi-1.0.16
wget https://github.com/fribidi/fribidi/releases/download/v1.0.16/fribidi-1.0.16.tar.xz
tar xf fribidi-1.0.16.tar.xz
cd fribidi-1.0.16

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "12-fribidi"
echo "=== FriBidi complete ==="
