#!/bin/bash
#
# BLFS build: libgpg-error-1.61
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./40-libgpg-error.sh [--force]
#
# Needed by libgcrypt, needed by lightdm. Build command has been
# identical across every version of this package for over a decade,
# confirmed via multiple book editions.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libgpg-error" "$1"

echo "=== Building libgpg-error 1.61 ==="

cd /root/src
rm -rf libgpg-error-1.61
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.61.tar.bz2
tar xf libgpg-error-1.61.tar.bz2
cd libgpg-error-1.61

./configure --prefix=/usr
make

make install
install -v -m644 -D README /usr/share/doc/libgpg-error-1.61/README

mark_done "12-libgpg-error"
echo "=== libgpg-error complete ==="
