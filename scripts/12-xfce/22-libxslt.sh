#!/bin/bash
#
# BLFS build: libxslt-1.1.45
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./22-libxslt.sh [--force]
#
# Needed by xfce4-dev-tools (provides xsltproc), a genuine hard
# requirement despite showing up as only "Recommended" in various
# other packages' dependency lists this whole project. libgcrypt
# skipped, only needed for a deprecated EXSLT crypto extension.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxslt" "$1"

echo "=== Building libxslt 1.1.45 ==="

cd /root/src
rm -rf libxslt-1.1.45
wget https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.45.tar.xz
tar xf libxslt-1.1.45.tar.xz
cd libxslt-1.1.45

./configure --prefix=/usr \
            --disable-static \
            --without-python \
            --docdir=/usr/share/doc/libxslt-1.1.45
make

make install

mark_done "12-libxslt"
echo "=== libxslt complete ==="
