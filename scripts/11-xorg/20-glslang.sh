#!/bin/bash
#
# BLFS build: glslang-16.2.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./20-glslang.sh [--force]
#
# This is the actual package Mesa's build system was missing
# (glslangValidator). Final link in the CMake -> SPIRV-Headers ->
# SPIRV-Tools -> Glslang chain.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-glslang" "$1"

echo "=== Building glslang 16.2.0 ==="

cd /root/src
rm -rf glslang-16.2.0
wget https://github.com/KhronosGroup/glslang/archive/16.2.0/glslang-16.2.0.tar.gz
tar xf glslang-16.2.0.tar.gz
cd glslang-16.2.0

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=Release         \
      -D ALLOW_EXTERNAL_SPIRV_TOOLS=ON    \
      -D BUILD_SHARED_LIBS=ON             \
      -D GLSLANG_TESTS=ON                 \
      -G Ninja ..
ninja

ninja install

mark_done "11-glslang"
echo "=== glslang complete ==="
echo ""
echo "=== That closes the Mesa dependency chain. Ready to retry Mesa. ==="
