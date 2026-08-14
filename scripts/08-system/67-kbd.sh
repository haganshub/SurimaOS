#!/bin/bash
#
# SurimaOS build: 8.69. Kbd-2.9.0
# Run INSIDE chroot. Usage: ./67-kbd.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-kbd"

echo "=== Building Kbd 2.9.0 ==="

cd /sources
rm -rf kbd-2.9.0
tar xf kbd-2.9.0.tar.xz
cd kbd-2.9.0

# Fixes inconsistent backspace/delete key behavior across i386 keymaps.
patch -Np1 -i ../kbd-2.9.0-backspace-1.patch

# Remove the redundant resizecons program, it needs the defunct
# svgalib, setfont covers normal use already.
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

time {
./configure --prefix=/usr --disable-vlock

make

make check

make install
}

cp -R -v docs/doc -T /usr/share/doc/kbd-2.9.0

mark_done "08-kbd"
echo "=== Kbd complete ==="
