# 04 - Kernel Configuration

## Baseline

Started from `make defconfig`, then applied the book's checklist
(devtmpfs, DRM/framebuffer, PCI MSI, IOMMU/IRQ_REMAP, x2APIC, cgroups,
stack protector, IPv6, tmpfs, inotify), plus hardware-specific stuff for
the 7280: CONFIG_BLK_DEV_NVME built in (not a module, no initramfs, and
it's NVMe not SATA), VFAT/MSDOS for the EFI System Partition, ext4 for
root.

## Menuconfig can silently lose your settings

Accidentally exited `make menuconfig` mid-session and it reverted two
settings I'd already confirmed (CONFIG_BLK_DEV_NVME, CONFIG_IRQ_REMAP), no
warning, nothing. Only caught it by grepping the saved .config afterward.

From then on: never trust menuconfig saved what you think it saved, grep
every critical setting after, and use scripts/config for anything that
actually matters:

```bash
./scripts/config --enable CONFIG_NAME
./scripts/config --module CONFIG_NAME
./scripts/config --disable CONFIG_NAME
make olddefconfig
```

Edits .config directly, no UI to accidentally exit out of.

## Wifi

Found the chip without lspci (not built yet) by reading
/sys/bus/pci/devices/*/uevent directly: vendor:device 8086:24FD, an Intel
Dual Band Wireless-AC 8265.

CONFIG_IWLWIFI had never been enabled by defconfig. Driver didn't exist
anywhere on the system. To fix:

1. Enabled CONFIG_CFG80211 (built-in), CONFIG_IWLWIFI and CONFIG_IWLMVM
   (both modules, firmware loads at runtime so no reason to build them
   in), then rebuilt the kernel.
2. Set a distinct LOCALVERSION (-wifi) for this rebuild so its modules
   land in their own /lib/modules/6.18.10-wifi/ instead of overwriting the
   working /lib/modules/6.18.10/. First attempt skipped the suffix and
   modules_install clobbered the working directory. Recovered from a
   backup I'd taken beforehand.
3. The 8265 needs a firmware blob (iwlwifi-8265-36.ucode) that can't be
   compiled, just has to exist in /lib/firmware/. Two download sources
   failed or 404'd, got it working from a GitHub mirror of linux-firmware
   (raw.githubusercontent.com/wkennington/linux-firmware).
4. Actual connectivity needed wpa_supplicant, a libnl-linked build, and a
   DHCP config extension for wl*-named interfaces (existing config only
   matched en*).

BLFS doesn't document iwd at all, despite it being a common choice on
other distros. The book's actual path is iw plus wpa_supplicant. Same kind
of gap hit again later with RPM/DNF, see `07-package-manager.md`. Worth
checking a package is actually in the current book's table of contents
before assuming it is.

## CONFIG_TUN, found via Tailscale

Weeks later, installing Tailscale (`06-networking-and-remote-access.md`)
turned up a second missing kernel option: CONFIG_TUN. tailscaled
crash-looped with an error message that named the problem directly. Same
fix as the wifi driver: scripts/config --module TUN, rebuild (fast, only
one option changed), modules_install, modprobe tun to load it without
rebooting.
