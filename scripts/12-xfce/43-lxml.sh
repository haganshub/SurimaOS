#!/bin/bash
#
# BLFS build: lxml-6.0.2 (Python module)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./43-lxml.sh [--force]
#
# Needed by itstool, needed by lightdm. Installed via pip3 per BLFS's
# modern Python-module convention (build wheel, install wheel).
# Real deps (libxml2, libxslt) both satisfied.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-lxml" "$1"

echo "=== Building lxml 6.0.2 (Python module) ==="

cd /root/src
rm -rf lxml-6.0.2*
wget https://files.pythonhosted.org/packages/source/l/lxml/lxml-6.0.2.tar.gz
tar xf lxml-6.0.2.tar.gz
cd lxml-6.0.2

pip3 wheel -w dist --no-build-isolation .

pip3 install --no-index --find-links=dist lxml

mark_done "12-lxml"
echo "=== lxml complete ==="
