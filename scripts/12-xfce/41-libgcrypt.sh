#!/bin/bash
#
# BLFS build: libgcrypt-1.12.2
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./41-libgcrypt.sh [--force]
#
# Needed by lightdm. Skipping the optional PDF/PostScript doc build
# (needs texlive, a large package we don't need for this).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libgcrypt" "$1"

echo "=== Building libgcrypt 1.12.2 ==="

cd /root/src
rm -rf libgcrypt-1.12.2
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.2.tar.bz2
tar xf libgcrypt-1.12.2.tar.bz2
cd libgcrypt-1.12.2

./configure --prefix=/usr
make

make install

mark_done "12-libgcrypt"
echo "=== libgcrypt complete ==="
