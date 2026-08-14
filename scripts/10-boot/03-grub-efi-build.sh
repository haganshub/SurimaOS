#!/bin/bash
#
# BLFS build: GRUB-2.14 for EFI
# Run INSIDE chroot. Usage: ./03-grub-efi-build.sh [--force]
#
# IMPORTANT SCOPE NOTE: this script ONLY builds the UEFI-capable GRUB
# binaries. It deliberately does NOT run grub-install, does NOT mount
# efivarfs, and does NOT touch any EFI variables. That's because
# efivarfs is a direct kernel interface to the PHYSICAL machine's real
# firmware NVRAM, chroot cannot isolate it. Since we're building on
# the ThinkCentre (not the 7280, the actual deployment target), running
# those steps here would write real persistent boot-entry data into
# the ThinkCentre's own UEFI firmware for no reason, there's no real
# ESP or target disk backing any of this yet.
#
# The actual grub-install / ESP setup / EFI variable registration is
# deferred to Phase 9, the real install onto the 7280's real hardware,
# where it will actually mean something. See DISTRO_ROADMAP.md Phase 9.
#
# We already built LFS's own (BIOS-only) GRUB back in Chapter 8, so
# per the book's instructions for that case, this only installs the
# additional EFI-specific components, not a full reinstall.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "blfs-grub-efi-build"

echo "=== Building GRUB 2.14 with UEFI support (build only, no install to firmware) ==="

unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS

cd /sources
rm -rf grub-2.14
tar xf grub-2.14.tar.xz
cd grub-2.14

time {
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror

make
}

# We already installed LFS's own GRUB in Chapter 8, so only install
# the additional EFI-specific components here, not a full reinstall.
make -C grub-core install

mark_done "blfs-grub-efi-build"
echo "=== GRUB EFI build complete ==="
echo ""
echo "=== IMPORTANT: grub-install, ESP setup, and EFI variable"
echo "=== registration are DEFERRED to Phase 9 (real install onto the"
echo "=== 7280). Do not run those steps against the ThinkCentre. ==="
