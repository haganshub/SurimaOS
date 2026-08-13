#!/bin/bash
#
# SurimaOS build: 8.34. Gettext-1.0 (final install, not the Chapter 7
# partial 3-binary version)
# Run INSIDE chroot. Usage: ./32-gettext.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gettext"

echo "=== Building Gettext 1.0 (final) ==="

cd /sources
rm -rf gettext-1.0
tar xf gettext-1.0.tar.xz
cd gettext-1.0

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-1.0

make

make check

make install
}

chmod -v 0755 /usr/lib/preloadable_libintl.so

mark_done "08-gettext"
echo "=== Gettext complete ==="
