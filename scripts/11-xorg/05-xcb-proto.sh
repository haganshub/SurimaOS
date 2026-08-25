#!/bin/bash
#
# BLFS build: xcb-proto-1.17.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./05-xcb-proto.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xcb-proto" "$1"

echo "=== Building xcb-proto 1.17.0 ==="

cd /root/src
rm -rf xcb-proto-1.17.0
wget https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.17.0.tar.xz
tar xf xcb-proto-1.17.0.tar.xz
cd xcb-proto-1.17.0

PYTHON=python3 ./configure $XORG_CONFIG

set +e
make check
set -e

make install

# Only relevant if upgrading from an older xcb-proto, harmless otherwise
rm -f $XORG_PREFIX/lib/pkgconfig/xcb-proto.pc

mark_done "11-xcb-proto"
echo "=== xcb-proto complete ==="
