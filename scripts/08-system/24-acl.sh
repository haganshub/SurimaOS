#!/bin/bash
#
# SurimaOS build: 8.26. Acl-2.3.2
# Run INSIDE chroot. Usage: ./24-acl.sh [--force]
#
# NOTE: test/cp.test is known to fail here, Coreutils isn't built with
# Acl support yet at this point in the book's order. Expected, not a
# real problem.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-acl"

echo "=== Building Acl 2.3.2 ==="

cd /sources
rm -rf acl-2.3.2
tar xf acl-2.3.2.tar.xz
cd acl-2.3.2

time {
time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.3.2

make

make check || echo "NOTE: test/cp.test failing here is expected (Coreutils has no Acl support yet)."

make install
}
}

mark_done "08-acl"
echo "=== Acl complete ==="
