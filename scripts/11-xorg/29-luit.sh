#!/bin/bash
#
# BLFS build: luit-20250912
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./29-luit.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-luit" "$1"

echo "=== Building luit 20250912 ==="

cd /root/src
rm -rf luit-20250912
wget https://invisible-mirror.net/archives/luit/luit-20250912.tgz
tar xf luit-20250912.tgz
cd luit-20250912

./configure $XORG_CONFIG
make

make install

mark_done "11-luit"
echo "=== luit complete ==="
