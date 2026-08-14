#!/bin/bash
#
# SurimaOS build: 8.64. Findutils-4.10.0 (final install)
# Run INSIDE chroot. Usage: ./62-findutils.sh [--force]
#
# NOTE: test suite runs as 'tester' user.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-findutils"

echo "=== Building Findutils 4.10.0 (final) ==="

cd /sources
rm -rf findutils-4.10.0
tar xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

time {
./configure --prefix=/usr --localstatedir=/var/lib/locate

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
}

mark_done "08-findutils"
echo "=== Findutils complete ==="
