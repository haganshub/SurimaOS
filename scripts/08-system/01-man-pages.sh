#!/bin/bash
#
# SurimaOS build: 8.3. Man-pages-6.17
# Run INSIDE chroot. Usage: ./01-man-pages.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-man-pages"

echo "=== Installing Man-pages 6.17 ==="

cd /sources
rm -rf man-pages-6.17
tar xf man-pages-6.17.tar.xz
cd man-pages-6.17

# Libxcrypt provides a better version of these, remove the originals.
rm -v man3/crypt*

make -R GIT=false prefix=/usr install

mark_done "08-man-pages"
echo "=== Man-pages complete ==="
