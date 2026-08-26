#!/bin/bash
#
# BLFS build: PyYAML-6.0.3 (Python module, needed by Mesa)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./15-pyyaml.sh [--force]
#
# NOTE: cython and libyaml are "Recommended," not required. Building
# without them for now, pure-Python fallback is fine for our purposes.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-pyyaml" "$1"

echo "=== Building PyYAML 6.0.3 ==="

cd /root/src
rm -rf pyyaml-6.0.3
wget https://files.pythonhosted.org/packages/source/P/PyYAML/pyyaml-6.0.3.tar.gz
tar xf pyyaml-6.0.3.tar.gz
cd pyyaml-6.0.3

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links dist --no-user PyYAML

mark_done "11-pyyaml"
echo "=== PyYAML complete ==="
