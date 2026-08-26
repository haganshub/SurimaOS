#!/bin/bash
#
# BLFS build: SPIRV-Tools-1.4.341.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./19-spirv-tools.sh [--force]
#
# Same caveat as SPIRV-Headers: couldn't pin the exact stable page,
# but the command structure is identical and consistent across every
# version checked. SPIRV-Headers_SOURCE_DIR=/usr matches where we just
# installed SPIRV-Headers.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-spirv-tools" "$1"

echo "=== Building SPIRV-Tools 1.4.341.0 ==="

cd /root/src
rm -rf SPIRV-Tools-vulkan-sdk-1.4.341.0
wget https://github.com/KhronosGroup/SPIRV-Tools/archive/vulkan-sdk-1.4.341.0/SPIRV-Tools-1.4.341.0.tar.gz
tar xf SPIRV-Tools-1.4.341.0.tar.gz
cd SPIRV-Tools-vulkan-sdk-1.4.341.0

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX=/usr    \
      -D CMAKE_BUILD_TYPE=Release     \
      -D SPIRV_WERROR=OFF             \
      -D BUILD_SHARED_LIBS=ON         \
      -D SPIRV_TOOLS_BUILD_STATIC=OFF \
      -D SPIRV-Headers_SOURCE_DIR=/usr \
      -G Ninja ..
ninja

ninja install

mark_done "11-spirv-tools"
echo "=== SPIRV-Tools complete ==="
