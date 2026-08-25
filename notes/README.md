# SurimaOS Build Notes

This directory holds the real technical story of building SurimaOS: every meaningful
deviation from the LFS/BLFS books, every bug found and fixed, every decision made
along the way. It's organized by build phase, roughly matching the order things
actually happened.

If you're building your own LFS-based distro and hit something similar, hopefully
one of these saves you the same debugging session it cost us.

## Index

- [00-preparation.md](00-preparation.md) - Host setup, remote access, project decisions
- [01-toolchain.md](01-toolchain.md) - LFS Chapter 5, cross-toolchain
- [02-temp-system.md](02-temp-system.md) - LFS Chapters 6-7, temporary tools & chroot
- [03-base-system.md](03-base-system.md) - LFS Chapter 8, the 81-package base system
- [04-kernel.md](04-kernel.md) - Kernel configuration, the wifi driver saga
- [05-bootloader-and-boot.md](05-bootloader-and-boot.md) - GRUB, UEFI, the real 7280 deployment
- [06-networking-and-remote-access.md](06-networking-and-remote-access.md) - SSH, sudo, wifi, Tailscale
- [07-package-manager.md](07-package-manager.md) - Why pacman, not dnf, and how it was built

Each file is meant to stand alone, you shouldn't need to read the others to follow
one phase's story, though later phases sometimes reference earlier decisions.
