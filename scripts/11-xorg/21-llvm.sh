#!/bin/bash
#
# BLFS build: LLVM-21.1.8 (with Clang, no compiler-rt, no tests)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./21-llvm.sh [--force]
#
# This is the real cost of the iris driver: iris hardwires a need for
# libclc, which needs SPIRV-LLVM-Translator, which needs actual LLVM
# libraries. Clang is included because libclc's own build needs a
# working clang to compile OpenCL C source. compiler-rt skipped
# (optional, not needed here). Tests skipped entirely, 19 extra SBU
# on top of an already 13 SBU build, and Mesa doesn't need LLVM's own
# tests to pass.
#
# This will take a long time. Run in tmux.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-llvm" "$1"

echo "=== Building LLVM 21.1.8 + Clang (this will take a LONG time) ==="

cd /root/src
rm -rf llvm-21.1.8.src
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-21.1.8.src.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-21.1.8.src.tar.xz
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-21.1.8.src.tar.xz

tar xf llvm-21.1.8.src.tar.xz
cd llvm-21.1.8.src

tar -xf ../llvm-cmake-21.1.8.src.tar.xz
tar -xf ../llvm-third-party-21.1.8.src.tar.xz
sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-21.1.8.src@' \
    -i CMakeLists.txt
sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-21.1.8.src@' \
    -i cmake/modules/HandleLLVMOptions.cmake

tar -xf ../clang-21.1.8.src.tar.xz -C tools
mv tools/clang-21.1.8.src tools/clang

grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt

mkdir -v build
cd build

time {
CC=gcc CXX=g++ \
cmake -D CMAKE_INSTALL_PREFIX=/usr    \
      -D CMAKE_SKIP_INSTALL_RPATH=ON  \
      -D LLVM_ENABLE_FFI=ON           \
      -D CMAKE_BUILD_TYPE=Release     \
      -D LLVM_BUILD_LLVM_DYLIB=ON     \
      -D LLVM_LINK_LLVM_DYLIB=ON      \
      -D LLVM_ENABLE_RTTI=ON          \
      -D LLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -D LLVM_BINUTILS_INCDIR=/usr/include \
      -D LLVM_INCLUDE_BENCHMARKS=OFF  \
      -D CLANG_DEFAULT_PIE_ON_LINUX=ON \
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
      -W no-dev -G Ninja ..

ninja
}

ninja install

mkdir -pv /etc/clang
for i in clang clang++; do
  echo -fstack-protector-strong > /etc/clang/$i.cfg
done

mark_done "11-llvm"
echo "=== LLVM + Clang complete ==="
