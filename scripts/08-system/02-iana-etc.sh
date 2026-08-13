#!/bin/bash
#
# SurimaOS build: 8.4. Iana-Etc-20260202
# Run INSIDE chroot. Usage: ./02-iana-etc.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-iana-etc"

echo "=== Installing Iana-Etc 20260202 ==="

cd /sources
rm -rf iana-etc-20260202
tar xf iana-etc-20260202.tar.gz
cd iana-etc-20260202

cp -v services protocols /etc

mark_done "08-iana-etc"
echo "=== Iana-Etc complete ==="
