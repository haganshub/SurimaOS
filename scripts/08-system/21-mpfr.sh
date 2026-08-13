#!/bin/bash
#
# SurimaOS build: 8.23. MPFR-4.2.2
# Run INSIDE chroot. Usage: ./21-mpfr.sh [--force]
#
# NOTE: test suite is explicitly critical per the book, do not skip.
# Book wants all 198 tests to pass.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-mpfr"

echo "=== Building MPFR 4.2.2 ==="

cd /sources
rm -rf mpfr-4.2.2
tar xf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2

time {
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2

make
make html
}

echo ""
echo "=== Running MPFR test suite (critical, do not skip). Book expects all 198 to pass. ==="
echo ""
set +e
make check 2>&1 | tee /root/mpfr-check-results.log
set -e

echo ""
echo "=== Review /root/mpfr-check-results.log, all 198 tests should pass. ==="
echo ""

make install
make install-html

mark_done "08-mpfr"
echo "=== MPFR complete ==="
