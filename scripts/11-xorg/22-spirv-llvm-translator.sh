#!/bin/bash
#
# BLFS build: SPIRV-LLVM-Translator-21.1.4
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./22-spirv-llvm-translator.sh [--force]
#
# Version confirmed paired with our LLVM-21.1.8 via the book's own
# real index page. Checks for libxml2 first since it's listed as a
# real requirement for this package and we haven't built it anywhere
# in this project yet, better to fail loudly and clearly than have
# cmake fail confusingly partway through.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-spirv-llvm-translator" "$1"

echo "=== Checking for libxml2 (required, not yet confirmed present) ==="
if ! pkg-config --exists libxml-2.0; then
  echo ""
  echo "libxml2 not found. This needs to be built first, it's not yet"
  echo "part of this project. Grab the BLFS libxml2 page before"
  echo "continuing, then re-run this script."
  echo ""
  exit 1
fi
echo "libxml2 found: $(pkg-config --modversion libxml-2.0)"

echo "=== Building SPIRV-LLVM-Translator 21.1.4 ==="

cd /root/src
rm -rf SPIRV-LLVM-Translator-21.1.4
wget https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/v21.1.4/SPIRV-LLVM-Translator-21.1.4.tar.gz
tar xf SPIRV-LLVM-Translator-21.1.4.tar.gz
cd SPIRV-LLVM-Translator-21.1.4

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=Release         \
      -D CMAKE_SKIP_INSTALL_RPATH=ON      \
      -D BUILD_SHARED_LIBS=ON             \
      -D LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr \
      -G Ninja ..
ninja

ninja install

mark_done "11-spirv-llvm-translator"
echo "=== SPIRV-LLVM-Translator complete ==="
