#!/bin/bash
#
# SurimaOS build: 8.13. Pcre2-10.47
# Run INSIDE chroot. Usage: ./11-pcre2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-pcre2"

echo "=== Building Pcre2 10.47 ==="

cd /sources
rm -rf pcre2-10.47
tar xf pcre2-10.47.tar.bz2
cd pcre2-10.47

time {
./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.47 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static

make

make check

make install
}

mark_done "08-pcre2"
echo "=== Pcre2 complete ==="
