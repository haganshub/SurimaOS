#!/bin/bash
#
# BLFS build: NASM (needed for libjpeg-turbo's SIMD acceleration)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./06-nasm.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-nasm" "$1"

echo "=== Building NASM 3.01 ==="

cd /root/src
rm -rf nasm-3.01
wget https://www.nasm.us/pub/nasm/releasebuilds/3.01/nasm-3.01.tar.xz
tar xf nasm-3.01.tar.xz
cd nasm-3.01

./configure --prefix=/usr
make

make install

mark_done "12-nasm"
echo "=== NASM complete ==="
