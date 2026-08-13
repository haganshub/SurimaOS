#!/bin/bash
#
# SurimaOS build: 8.19. DejaGNU-1.6.3
# Run INSIDE chroot. Usage: ./17-dejagnu.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-dejagnu"

echo "=== Building DejaGNU 1.6.3 ==="

cd /sources
rm -rf dejagnu-1.6.3
tar xf dejagnu-1.6.3.tar.gz
cd dejagnu-1.6.3

rm -rf build
mkdir -v build
cd       build

time {
../configure --prefix=/usr

makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi

make check

make install
}

install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

mark_done "08-dejagnu"
echo "=== DejaGNU complete ==="
echo ""
echo "=== Test-support packages (Tcl, Expect, DejaGNU) all complete. ==="
