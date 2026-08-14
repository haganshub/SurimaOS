#!/bin/bash
#
# SurimaOS build: 8.71. Make-4.4.1 (final install)
# Run INSIDE chroot. Usage: ./69-make.sh [--force]
#
# NOTE: test suite runs as 'tester' user.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-make"

echo "=== Building Make 4.4.1 (final) ==="

cd /sources
rm -rf make-4.4.1
tar xf make-4.4.1.tar.gz
cd make-4.4.1

time {
./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
}

mark_done "08-make"
echo "=== Make complete ==="
