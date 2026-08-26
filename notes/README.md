# SurimaOS Build Notes

Notes from building SurimaOS: the real deviations from the LFS/BLFS books, bugs
I ran into, decisions I made. Organized by build phase, roughly in order.

If you're building your own LFS-based distro and hit something similar,
hopefully one of these saves you a debugging session.

## Index

- [00-preparation.md](00-preparation.md) - Host setup, remote access, early decisions
- [01-toolchain.md](01-toolchain.md) - LFS Chapter 5, cross-toolchain
- [02-temp-system.md](02-temp-system.md) - LFS Chapters 6-7, temporary tools and chroot
- [03-base-system.md](03-base-system.md) - LFS Chapter 8, the 81-package base system
- [04-kernel.md](04-kernel.md) - Kernel config, the wifi driver saga
- [05-bootloader-and-boot.md](05-bootloader-and-boot.md) - GRUB, UEFI, deploying to the 7280
- [06-networking-and-remote-access.md](06-networking-and-remote-access.md) - SSH, sudo, wifi, Tailscale
- [07-package-manager.md](07-package-manager.md) - Why pacman, not dnf
- [08-xorg-and-mesa.md](08-xorg-and-mesa.md) - Xorg build environment, and the Mesa/libclc/LLVM saga
