#!/bin/bash
#
# BLFS build: Mako-1.3.10 (Python module, needed by Mesa)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./14-mako.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-mako" "$1"

echo "=== Building Mako 1.3.10 ==="

cd /root/src
rm -rf mako-1.3.10
wget https://files.pythonhosted.org/packages/source/M/Mako/mako-1.3.10.tar.gz
tar xf mako-1.3.10.tar.gz
cd mako-1.3.10

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links dist --no-user Mako

mark_done "11-mako"
echo "=== Mako complete ==="
