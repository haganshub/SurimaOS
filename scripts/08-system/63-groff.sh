#!/bin/bash
#
# SurimaOS build: 8.65. Groff-1.23.0
# Run INSIDE chroot. Usage: ./63-groff.sh [--force]
#
# NOTE: paper size defaulted to "letter" (US location context). If
# this is wrong, change PAGE below, or override later by echoing
# "A4" or "letter" to /etc/papersize.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-groff"

echo "=== Building Groff 1.23.0 ==="

cd /sources
rm -rf groff-1.23.0
tar xf groff-1.23.0.tar.gz
cd groff-1.23.0

time {
PAGE=letter ./configure --prefix=/usr

make

make check

make install
}

mark_done "08-groff"
echo "=== Groff complete ==="
