#!/bin/bash
#
# BLFS build: itstool-2.0.7
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./44-itstool.sh [--force]
#
# Needed by lightdm. Real deps (docbook-xml, lxml) both satisfied.
# Required patch switches to lxml for XML handling instead of the
# deprecated Python module from libxml2.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-itstool" "$1"

echo "=== Building itstool 2.0.7 ==="

cd /root/src
rm -rf itstool-2.0.7
wget https://github.com/itstool/itstool/archive/2.0.7/itstool-2.0.7.tar.gz
wget https://www.linuxfromscratch.org/patches/blfs/svn/itstool-2.0.7-lxml-1.patch
tar xf itstool-2.0.7.tar.gz
cd itstool-2.0.7

patch -Np1 -i ../itstool-2.0.7-lxml-1.patch

PYTHON=/usr/bin/python3 ./autogen.sh --prefix=/usr
make

make install

mark_done "12-itstool"
echo "=== itstool complete ==="
