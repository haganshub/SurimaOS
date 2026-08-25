#!/bin/bash
#
# BLFS build: libXdmcp-1.1.5
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./04-libXdmcp.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libXdmcp" "$1"

echo "=== Building libXdmcp 1.1.5 ==="

cd /root/src
rm -rf libXdmcp-1.1.5
wget https://www.x.org/pub/individual/lib/libXdmcp-1.1.5.tar.xz
tar xf libXdmcp-1.1.5.tar.xz
cd libXdmcp-1.1.5

./configure $XORG_CONFIG --docdir='${datadir}'/doc/libXdmcp-1.1.5

make

set +e
make check
set -e

make install

mark_done "11-libXdmcp"
echo "=== libXdmcp complete ==="
