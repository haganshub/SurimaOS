#!/bin/bash
#
# SurimaOS build: 8.28. Libxcrypt-4.5.2
# Run INSIDE chroot. Usage: ./26-libxcrypt.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libxcrypt"

echo "=== Building Libxcrypt 4.5.2 ==="

cd /sources
rm -rf libxcrypt-4.5.2
tar xf libxcrypt-4.5.2.tar.xz
cd libxcrypt-4.5.2

# Fix required by glibc-2.43+.
sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

time {
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens

make

make check

make install
}

mark_done "08-libxcrypt"
echo "=== Libxcrypt complete ==="
