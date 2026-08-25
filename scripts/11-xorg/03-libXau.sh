#!/bin/bash
#
# BLFS build: libXau-1.0.12
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./03-libXau.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libXau" "$1"

echo "=== Building libXau 1.0.12 ==="

cd /root/src
rm -rf libXau-1.0.12
wget https://www.x.org/pub/individual/lib/libXau-1.0.12.tar.xz
tar xf libXau-1.0.12.tar.xz
cd libXau-1.0.12

./configure $XORG_CONFIG

make

set +e
make check
set -e

make install

mark_done "11-libXau"
echo "=== libXau complete ==="
