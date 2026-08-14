#!/bin/bash
#
# SurimaOS build: 8.80. Man-DB-2.13.1
# Run INSIDE chroot. Usage: ./78-man-db.sh [--force]
#
# NOTE: --with-browser/--with-vgrind/--with-grap point to programs
# (lynx, vgrind, grap) not installed in LFS or BLFS scope here, that's
# expected per the book, just sets defaults for if they're added later.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-man-db"

echo "=== Building Man-DB 2.13.1 ==="

cd /sources
rm -rf man-db-2.13.1
tar xf man-db-2.13.1.tar.xz
cd man-db-2.13.1

time {
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap

make

make check

make install
}

mark_done "08-man-db"
echo "=== Man-DB complete ==="
