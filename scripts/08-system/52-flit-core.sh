#!/bin/bash
#
# SurimaOS build: 8.54. Flit-Core-3.12.0
# Run INSIDE chroot. Usage: ./52-flit-core.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-flit-core"

echo "=== Building Flit-Core 3.12.0 ==="

cd /sources
rm -rf flit_core-3.12.0
tar xf flit_core-3.12.0.tar.gz
cd flit_core-3.12.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist flit_core

mark_done "08-flit-core"
echo "=== Flit-Core complete ==="
