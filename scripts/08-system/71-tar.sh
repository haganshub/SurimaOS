#!/bin/bash
#
# SurimaOS build: 8.73. Tar-1.35 (final install)
# Run INSIDE chroot. Usage: ./71-tar.sh [--force]
#
# NOTE: one known-expected test failure, "capabilities: binary
# store/restore", since LFS lacks SELinux. May instead be skipped
# entirely depending on host kernel/filesystem support for extended
# attributes. Not treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-tar"

echo "=== Building Tar 1.35 (final) ==="

cd /sources
rm -rf tar-1.35
tar xf tar-1.35.tar.xz
cd tar-1.35

time {
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make
}

echo ""
echo "=== Running Tar test suite. 'capabilities: binary store/restore'"
echo "=== failing is expected (LFS lacks SELinux), safe to ignore. ==="
echo ""
set +e
make check 2>&1 | tee /root/tar-check-results.log
set -e
echo ""

make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

mark_done "08-tar"
echo "=== Tar complete ==="
