#!/bin/bash
#
# SurimaOS build: 8.66. GRUB-2.14
# Run INSIDE chroot. Usage: ./64-grub.sh [--force]
#
# NOTE: test suite deliberately NOT run, the book explicitly says it's
# not recommended since most tests depend on packages outside LFS's
# scope. This is the bootloader package itself, actual boot setup
# happens later in Chapter 10.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-grub"

echo "=== Building GRUB 2.14 ==="

# Don't let any custom optimization flags leak into a bootloader build.
unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS

cd /sources
rm -rf grub-2.14
tar xf grub-2.14.tar.xz
cd grub-2.14

# Fix a bug introduced in grub-2.14 itself.
sed 's/--image-base/--nonexist-linker-option/' -i configure

time {
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror

make

make install
}

mark_done "08-grub"
echo "=== GRUB complete ==="
