#!/bin/bash
#
# SurimaOS build: 8.32. Sed-4.9 (final install)
# Run INSIDE chroot. Usage: ./30-sed.sh [--force]
#
# NOTE: test suite runs as the 'tester' user, same pattern as GCC.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-sed"

echo "=== Building Sed 4.9 (final) ==="

cd /sources
rm -rf sed-4.9
tar xf sed-4.9.tar.xz
cd sed-4.9

time {
./configure --prefix=/usr

make
make html

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9
}

mark_done "08-sed"
echo "=== Sed complete ==="
