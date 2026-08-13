#!/bin/bash
#
# SurimaOS build: 8.25. Attr-2.5.2
# Run INSIDE chroot. Usage: ./23-attr.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-attr"

echo "=== Building Attr 2.5.2 ==="

cd /sources
rm -rf attr-2.5.2
tar xf attr-2.5.2.tar.gz
cd attr-2.5.2

time {
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2

make

make check

make install
}

mark_done "08-attr"
echo "=== Attr complete ==="
