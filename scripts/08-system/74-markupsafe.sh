#!/bin/bash
#
# SurimaOS build: 8.76. MarkupSafe-3.0.3
# Run INSIDE chroot. Usage: ./74-markupsafe.sh [--force]
#
# NOTE: no test suite for this package.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-markupsafe"

echo "=== Building MarkupSafe 3.0.3 ==="

cd /sources
rm -rf markupsafe-3.0.3
tar xf markupsafe-3.0.3.tar.gz
cd markupsafe-3.0.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Markupsafe

mark_done "08-markupsafe"
echo "=== MarkupSafe complete ==="
