#!/bin/bash
#
# BLFS build: Mesa-25.3.5
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./16-mesa.sh [--force]
#
# DECISIONS (flag to reconsider if wrong):
#   - platforms=x11 only, not wayland: XFCE doesn't use Wayland in this
#     book (only GNOME/KDE do), no reason to build it.
#   - gallium-drivers=iris,softpipe: iris is the real driver for our
#     confirmed hardware (Intel HD 620, Kaby Lake). softpipe is a CPU
#     fallback like the book suggests, but unlike llvmpipe it needs no
#     separate LLVM config, just links against the LLVM we already
#     built.
#   - vulkan-drivers="" (empty): Vulkan isn't needed for XFCE or a
#     working desktop, only specific apps use it. Kept out to limit
#     scope, LLVM was already unavoidable via iris's libclc
#     requirement, no reason to add Vulkan's own driver surface on
#     top of that.
#   - No explicit opencl flag: earlier attempt guessed
#     "-D gallium-opencl=disabled" to dodge the libclc requirement,
#     that option doesn't exist in this Mesa version, and it turned
#     out iris hardwires the libclc need regardless of any flag
#     (confirmed by reading meson.build directly). Real fix was
#     building the whole libclc chain (CMake, SPIRV-Headers,
#     SPIRV-Tools, Glslang, LLVM+Clang, libxml2, Git,
#     SPIRV-LLVM-Translator, libclc), not finding a flag to skip it.
#   - video-codecs left at Mesa's own default (we never pass
#     video-codecs=all). The book warns that "all" can raise patent
#     issues if redistributing compiled binaries, and SurimaOS is
#     headed for public GitHub distribution, so this isn't just
#     boilerplate caution here.
#   - No test suite run (needs meson reconfigure + real GPU access,
#     and 1.4 extra SBU on top of an already long build).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-mesa" "$1"

echo "=== Building Mesa 25.3.5 (this will take a while) ==="

cd /root/src
rm -rf mesa-25.3.5
wget https://mesa.freedesktop.org/archive/mesa-25.3.5.tar.xz
tar xf mesa-25.3.5.tar.xz
cd mesa-25.3.5

mkdir build
cd build

time {
meson setup ..                    \
      --prefix=$XORG_PREFIX       \
      --buildtype=release         \
      -D platforms=x11            \
      -D gallium-drivers=iris,softpipe \
      -D vulkan-drivers=""        \
      -D valgrind=disabled        \
      -D libunwind=disabled

ninja
}

ninja install

mark_done "11-mesa"
echo "=== Mesa complete ==="
