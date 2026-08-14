#!/bin/bash
#
# SurimaOS build: 8.77. Jinja2-3.1.6
# Run INSIDE chroot. Usage: ./75-jinja2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-jinja2"

echo "=== Building Jinja2 3.1.6 ==="

cd /sources
rm -rf jinja2-3.1.6
tar xf jinja2-3.1.6.tar.gz
cd jinja2-3.1.6

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Jinja2

mark_done "08-jinja2"
echo "=== Jinja2 complete ==="
