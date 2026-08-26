#!/bin/bash
#
# BLFS build: libclc-21.1.8
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./25-libclc.sh [--force]
#
# Version confirmed from Mesa's own BLFS page dependency list
# ("libclc-21.1.8"), matching our LLVM-21.1.8. The actual package this
# entire chain was for. Note: libclc's own BLFS page downloads the
# FULL llvm-project monorepo tarball just to get the libclc/
# subdirectory, we already have a real LLVM build so this is a bit
# wasteful, but matches the book exactly rather than risking a subtly
# different libclc-only checkout.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-libclc" "$1"

echo "=== Building libclc 21.1.8 ==="

cd /root/src
rm -rf llvm-project-21.1.8.src
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-project-21.1.8.src.tar.xz
tar xf llvm-project-21.1.8.src.tar.xz
cd llvm-project-21.1.8.src

mkdir -p libclc/build
cd libclc/build

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -G Ninja ..
ninja

ninja install

mark_done "11-libclc"
echo "=== libclc complete ==="
echo ""
echo "=== That closes the ENTIRE Mesa dependency chain. Ready to retry Mesa. ==="
