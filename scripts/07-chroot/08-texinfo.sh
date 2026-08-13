#!/bin/bash
#
# SurimaOS build: 7.11. Texinfo-7.2
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Texinfo 7.2 ==="

cd /sources
rm -rf texinfo-7.2
tar xf texinfo-7.2.tar.xz
cd texinfo-7.2

time {
./configure --prefix=/usr

make -j$(nproc)

make install
}

echo "=== Texinfo complete ==="
