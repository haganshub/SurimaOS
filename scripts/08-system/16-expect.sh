#!/bin/bash
#
# SurimaOS build: 8.18. Expect-5.45.4
# Run INSIDE chroot. Usage: ./16-expect.sh [--force]
#
# IMPORTANT: this script includes a hard gate on PTY functionality
# before proceeding. The book is explicit that if this fails, several
# other packages' test suites (Bash, Binutils, GCC, GDBM, Expect
# itself) can fail "catastrophically" later, and the fix requires
# leaving chroot entirely and re-checking Chapter 7.3's virtual
# filesystem mounts. Better to catch it here than three packages from
# now with a confusing unrelated-looking failure.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-expect"

echo "=== Verifying PTY functionality before building Expect ==="
PTY_TEST_OUTPUT=$(python3 -c 'from pty import spawn; spawn(["echo", "ok"])' 2>&1)
echo "$PTY_TEST_OUTPUT"

if ! echo "$PTY_TEST_OUTPUT" | grep -q "^ok"; then
  echo ""
  echo "!!! PTY TEST FAILED. Expected output 'ok', got the above instead."
  echo "!!! This must be fixed before continuing, or later test suites"
  echo "!!! (Bash, Binutils, GCC, GDBM, Expect) may fail catastrophically."
  echo "!!! Exit chroot, re-check Chapter 7.3 virtual filesystem mounts"
  echo "!!! (especially devpts), remount if needed, and re-enter chroot."
  exit 1
fi

echo "=== PTY test passed ==="
echo ""
echo "=== Building Expect 5.45.4 ==="

cd /sources
rm -rf expect5.45.4
tar xf expect5.45.4.tar.gz
cd expect5.45.4

patch -Np1 -i ../expect-5.45.4-gcc15-1.patch

time {
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make

make test

make install
}

ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

mark_done "08-expect"
echo "=== Expect complete ==="
