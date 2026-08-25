#!/bin/bash
#
# BLFS build: util-macros-1.20.2
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./01-util-macros.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-util-macros" "$1"

echo "=== Building util-macros 1.20.2 ==="

cd /root/src
rm -rf util-macros-1.20.2
wget https://www.x.org/pub/individual/util/util-macros-1.20.2.tar.xz
tar xf util-macros-1.20.2.tar.xz
cd util-macros-1.20.2

./configure $XORG_CONFIG

make install

mark_done "11-util-macros"
echo "=== util-macros complete ==="
