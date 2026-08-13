#!/bin/bash
#
# SurimaOS build: 8.16. Flex-2.6.4 (final install)
# Run INSIDE chroot. Usage: ./14-flex.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-flex"

echo "=== Building Flex 2.6.4 (final) ==="

cd /sources
rm -rf flex-2.6.4
tar xf flex-2.6.4.tar.gz
cd flex-2.6.4

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/flex-2.6.4

make

make check

make install
}

ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

mark_done "08-flex"
echo "=== Flex complete ==="
