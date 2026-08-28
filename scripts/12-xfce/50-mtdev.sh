#!/bin/bash
#
# BLFS build: mtdev-1.1.6
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./50-mtdev.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-mtdev" "$1"

echo "=== Building mtdev 1.1.6 ==="

cd /root/src
rm -rf mtdev-1.1.6
wget https://bitmath.org/code/mtdev/mtdev-1.1.6.tar.bz2
tar xf mtdev-1.1.6.tar.bz2
cd mtdev-1.1.6

./configure --prefix=/usr --disable-static
make

make install

mark_done "12-mtdev"
echo "=== mtdev complete ==="
