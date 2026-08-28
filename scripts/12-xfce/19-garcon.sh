#!/bin/bash
#
# BLFS build: Garcon-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./19-garcon.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-garcon" "$1"

echo "=== Building Garcon 4.20.0 ==="

cd /root/src
rm -rf garcon-4.20.0
wget https://archive.xfce.org/src/xfce/garcon/4.20/garcon-4.20.0.tar.bz2
tar xf garcon-4.20.0.tar.bz2
cd garcon-4.20.0

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --sysconfdir=/etc $INTROSPECTION_FLAG

make

make install

mark_done "12-garcon"
echo "=== Garcon complete ==="
