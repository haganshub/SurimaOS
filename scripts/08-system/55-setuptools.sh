#!/bin/bash
#
# SurimaOS build: 8.57. Setuptools-82.0.0
# Run INSIDE chroot. Usage: ./55-setuptools.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-setuptools"

echo "=== Building Setuptools 82.0.0 ==="

cd /sources
rm -rf setuptools-82.0.0
tar xf setuptools-82.0.0.tar.gz
cd setuptools-82.0.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist setuptools

mark_done "08-setuptools"
echo "=== Setuptools complete ==="
