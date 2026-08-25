#!/bin/bash
#
# BLFS build: libxcb-1.17.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./06-libxcb.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libxcb" "$1"

echo "=== Building libxcb 1.17.0 ==="

cd /root/src
rm -rf libxcb-1.17.0
wget https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.17.0.tar.xz
tar xf libxcb-1.17.0.tar.xz
cd libxcb-1.17.0

./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.17.0

LC_ALL=en_US.UTF-8 make

set +e
make check
set -e

make install

# We're building as root directly, so this ownership fix is a no-op in
# our setup, kept since it's harmless and matches the book.
chown -Rv root:root $XORG_PREFIX/share/doc/libxcb-1.17.0

mark_done "11-libxcb"
echo "=== libxcb complete ==="
