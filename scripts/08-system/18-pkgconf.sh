#!/bin/bash
#
# SurimaOS build: 8.20. Pkgconf-2.5.1
# Run INSIDE chroot. Usage: ./18-pkgconf.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-pkgconf"

echo "=== Building Pkgconf 2.5.1 ==="

cd /sources
rm -rf pkgconf-2.5.1
tar xf pkgconf-2.5.1.tar.xz
cd pkgconf-2.5.1

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/pkgconf-2.5.1

make

make install
}

ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

mark_done "08-pkgconf"
echo "=== Pkgconf complete ==="
