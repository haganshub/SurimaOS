#!/bin/bash
#
# SurimaOS build: 8.36. Grep-3.12 (final install)
# Run INSIDE chroot. Usage: ./34-grep.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-grep"

echo "=== Building Grep 3.12 (final) ==="

cd /sources
rm -rf grep-3.12
tar xf grep-3.12.tar.xz
cd grep-3.12

# Remove an egrep/fgrep warning that makes some other packages' tests fail.
sed -i "s/echo/#echo/" src/egrep.sh

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-grep"
echo "=== Grep complete ==="
