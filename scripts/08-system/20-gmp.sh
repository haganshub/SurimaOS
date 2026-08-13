#!/bin/bash
#
# SurimaOS build: 8.22. GMP-6.3.0
# Run INSIDE chroot. Usage: ./20-gmp.sh [--force]
#
# NOTE: test suite is explicitly critical per the book, do not skip.
# Book wants at least 199 tests passed, verified via awk count below.
# If gmp's CPU auto-detection misidentifies capabilities, tests can
# fail with "Illegal instruction", the book's fix for that is
# reconfiguring with --host=none-linux-gnu, flagged below if the
# pass count looks low rather than attempted automatically.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gmp"

echo "=== Building GMP 6.3.0 ==="

cd /sources
rm -rf gmp-6.3.0
tar xf gmp-6.3.0.tar.xz
cd gmp-6.3.0

# Compatibility fix for gcc-15 and later.
sed -i '/long long t1;/,+1s/()/(...)/' configure

time {
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0

make
make html
}

echo ""
echo "=== Running GMP test suite (critical, do not skip). ==="
echo ""
set +e
make check 2>&1 | tee gmp-check-log
set -e

PASS_COUNT=$(awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log)
echo ""
echo "=== GMP tests passed: $PASS_COUNT (book requires at least 199) ==="
if [ -z "$PASS_COUNT" ] || [ "$PASS_COUNT" -lt 199 ]; then
  echo "!!! WARNING: pass count below the book's minimum of 199."
  echo "!!! If failures mention 'Illegal instruction', the CPU"
  echo "!!! auto-detection may have misidentified capabilities. The"
  echo "!!! book's fix is reconfiguring with --host=none-linux-gnu"
  echo "!!! and rebuilding. Review gmp-check-log before proceeding."
fi
echo ""

make install
make install-html

mark_done "08-gmp"
echo "=== GMP complete ==="
