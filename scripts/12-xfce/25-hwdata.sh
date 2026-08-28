#!/bin/bash
#
# BLFS build: hwdata-0.404
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./25-hwdata.sh [--force]
#
# Genuine hard requirement for libdisplay-info (needs pnp.ids for
# monitor vendor lookups), surfaced only when meson explicitly
# demanded it despite showing as optional elsewhere. Data-only
# package, no real compilation.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-hwdata" "$1"

echo "=== Building hwdata 0.404 ==="

cd /root/src
rm -rf hwdata-0.404
wget https://github.com/vcrhonek/hwdata/archive/v0.404/hwdata-0.404.tar.gz
tar xf hwdata-0.404.tar.gz
cd hwdata-0.404

./configure --prefix=/usr

make install

mark_done "12-hwdata"
echo "=== hwdata complete ==="
