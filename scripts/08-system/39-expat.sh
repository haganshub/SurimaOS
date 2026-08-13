#!/bin/bash
#
# SurimaOS build: 8.41. Expat-2.7.4
# Run INSIDE chroot. Usage: ./39-expat.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-expat"

echo "=== Building Expat 2.7.4 ==="

cd /sources
rm -rf expat-2.7.4
tar xf expat-2.7.4.tar.xz
cd expat-2.7.4

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.4

make

make check

make install
}

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.4

mark_done "08-expat"
echo "=== Expat complete ==="
