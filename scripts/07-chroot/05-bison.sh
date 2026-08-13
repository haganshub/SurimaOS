#!/bin/bash
#
# SurimaOS build: 7.8. Bison-3.8.2
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Bison 3.8.2 ==="

cd /sources
rm -rf bison-3.8.2
tar xf bison-3.8.2.tar.xz
cd bison-3.8.2

time {
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make -j$(nproc)

make install
}

echo "=== Bison complete ==="
