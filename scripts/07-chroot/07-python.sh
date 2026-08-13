#!/bin/bash
#
# SurimaOS build: 7.10. Python-3.14.3
# Run INSIDE the chroot environment, as root.
#
# NOTE: During make, an "ssl module... requires OpenSSL 1.1.1 or newer"
# message is expected and harmless at this stage (OpenSSL isn't
# installed yet, that module gets built properly in Chapter 8). Only
# worry if the overall make command itself fails.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Python 3.14.3 ==="

cd /sources
rm -rf Python-3.14.3
tar xf Python-3.14.3.tar.xz
cd Python-3.14.3

time {
./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython

make -j$(nproc)

make install
}

echo "=== Python complete ==="
