#!/bin/bash
#
# SurimaOS build: 8.21. Binutils-2.46.0 (final install)
# Run INSIDE chroot. Usage: ./19-binutils.sh [--force]
#
# NOTE: test suite is explicitly critical per the book, do not skip.
# One gprofng-related test is known/expected to fail. Not treated as
# fatal here, results captured for review, same pattern as Glibc.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-binutils"

echo "=== Building Binutils 2.46.0 (final) ==="

cd /sources
rm -rf binutils-2.46.0
tar xf binutils-2.46.0.tar.xz
cd binutils-2.46.0

rm -rf build
mkdir -v build
cd       build

time {
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu

make tooldir=/usr
}

echo ""
echo "=== Running Binutils test suite (critical, do not skip). ==="
echo ""
set +e
make -k check 2>&1 | tee /root/binutils-check-results.log
set -e

echo ""
echo "=== Failed tests: ==="
grep '^FAIL:' /root/binutils-check-results.log || echo "(none found)"
echo ""
echo "=== One gprofng-related test failure is known/expected. Review"
echo "=== the list above against that before trusting this build. ==="
echo ""

make tooldir=/usr install

rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/

mark_done "08-binutils"
echo "=== Binutils complete ==="
