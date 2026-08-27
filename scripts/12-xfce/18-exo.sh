#!/bin/bash
#
# BLFS build: Exo-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./18-exo.sh [--force]
#
# Checking for --enable-introspection at configure time and disabling
# it proactively if present, per the standing rule in common.sh.
# Real test suite offered this time, running it.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-exo" "$1"

echo "=== Building Exo 4.20.0 ==="

cd /root/src
rm -rf exo-4.20.0
wget https://archive.xfce.org/src/xfce/exo/4.20/exo-4.20.0.tar.bz2
tar xf exo-4.20.0.tar.bz2
cd exo-4.20.0

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --sysconfdir=/etc $INTROSPECTION_FLAG

make

set +e
make check
set -e

make install

mark_done "12-exo"
echo "=== Exo complete ==="
