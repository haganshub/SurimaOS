#!/bin/bash
#
# BLFS build: SPIRV-Headers-1.4.341.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./18-spirv-headers.sh [--force]
#
# NOTE: couldn't pin the exact stable-13.0-systemd BLFS page for this
# one (search kept returning the dev branch or unrelated versions),
# but the command structure is identical and simple across every
# version found (headers-only package, no compilation). Version number
# (1.4.341.0) confirmed from the real book's own table of contents
# fetched earlier this session. Worth a quick sanity check that the
# download actually contains real header files before moving on.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-spirv-headers" "$1"

echo "=== Building SPIRV-Headers 1.4.341.0 ==="

cd /root/src
rm -rf SPIRV-Headers-vulkan-sdk-1.4.341.0
wget https://github.com/KhronosGroup/SPIRV-Headers/archive/vulkan-sdk-1.4.341.0/SPIRV-Headers-1.4.341.0.tar.gz
tar xf SPIRV-Headers-1.4.341.0.tar.gz
cd SPIRV-Headers-vulkan-sdk-1.4.341.0

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX=/usr -G Ninja ..
ninja

ninja install

mark_done "11-spirv-headers"
echo "=== SPIRV-Headers complete ==="
echo ""
echo "=== Sanity check: confirm real header files landed ==="
ls -la /usr/include/spirv/
