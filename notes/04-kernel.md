# 04 — Kernel Configuration

## Baseline approach

`make defconfig` was used as the starting point, per the book's own
recommendation for a first build, then the book's full manual checklist
(devtmpfs, DRM/framebuffer settings, PCI MSI, IOMMU/IRQ_REMAP, x2APIC,
cgroups, stack protector, IPv6, tmpfs, inotify) was applied on top, plus
hardware-specific additions for the actual target (Latitude 7280):
`CONFIG_BLK_DEV_NVME` built in (not a module, since there's no initramfs
and the storage is NVMe, not SATA), VFAT/MSDOS filesystem support for the
EFI System Partition, and ext4 for root.

## Menuconfig is not a reliable way to set critical config

Manually navigating `make menuconfig` and accidentally exiting mid-session
silently reverted two already-confirmed settings (`CONFIG_BLK_DEV_NVME` and
`CONFIG_IRQ_REMAP`) without any error or warning. This wasn't caught until
a `grep` audit of the saved `.config` file turned up the missing settings,
purely by habit of double-checking rather than trusting the UI.

**Lesson, applied for the rest of the project:** never trust that a
menuconfig session actually saved what you think it saved. Verify every
critical setting afterward with `grep`, and prefer the kernel's own
`scripts/config` tool for anything that actually matters:

```bash
./scripts/config --enable CONFIG_NAME
./scripts/config --module CONFIG_NAME
./scripts/config --disable CONFIG_NAME
make olddefconfig   # resolves any newly-exposed dependencies non-interactively
```

This is deterministic and immune to accidental-exit problems, since it
edits the `.config` file directly rather than through an interactive UI.

## The wifi driver saga

The target hardware's wifi chip was identified without `lspci` (not yet
built at the time) by reading `/sys/bus/pci/devices/*/uevent` directly:
vendor:device `8086:24FD`, which is an Intel Dual Band Wireless-AC 8265, a
well-supported, mainline chip.

`CONFIG_IWLWIFI` had never been enabled by `defconfig`, so the driver
didn't exist anywhere on the built system, not as a module, not built in.
This required:

1. Enabling `CONFIG_CFG80211` (built-in), `CONFIG_IWLWIFI` and
   `CONFIG_IWLMVM` (both as modules, since firmware loading happens at
   runtime, there's no reason for these to be built-in) via
   `scripts/config`, then a real kernel rebuild.
2. A distinct `LOCALVERSION` (`-wifi`) was set for this rebuild
   specifically, so its modules install to their own separate
   `/lib/modules/6.18.10-wifi/` directory rather than colliding with the
   already-working `/lib/modules/6.18.10/`. The first attempt at this
   rebuild skipped the version suffix and `make modules_install` silently
   overwrote the working kernel's modules directory; recovered cleanly
   from a manual backup copy taken beforehand.
3. The Intel 8265 needs a proprietary firmware blob
   (`iwlwifi-8265-36.ucode`) that can't be compiled, it just has to be
   present in `/lib/firmware/`. Two attempted download sources failed
   silently or 404'd; it was eventually sourced successfully from a GitHub
   mirror of the upstream `linux-firmware` project
   (`raw.githubusercontent.com/wkennington/linux-firmware`).
4. Actual network connectivity required `wpa_supplicant` (not `iwd`, see
   note below) plus a `libnl`-linked build, and a DHCP config extension for
   `wl*`-named interfaces (the existing config only matched `en*`).

### `iwd` is not documented in BLFS

An early assumption that `iwd` would be the natural choice for wifi
connection management turned out to be wrong: BLFS's actual table of
contents does not include an `iwd` page at all. The book's real,
documented path for wireless connectivity is `iw` (interface control) and
`wpa_supplicant` (the connection/authentication daemon). This is the same
category of gap later hit again with RPM/DNF, see `07-package-manager.md`,
worth specifically checking a package actually exists in the current
book's TOC before assuming it does, rather than relying on general Linux
knowledge about what's "normally" used.

## A second kernel gap, found via Tailscale

Weeks after the wifi driver work, installing Tailscale (see
`06-networking-and-remote-access.md`) surfaced a second, unrelated missing
kernel feature: `CONFIG_TUN`. Tailscale's daemon crash-looped with a clear,
self-diagnosing error message pointing directly at the missing TUN/TAP
driver. Fixed with the exact same pattern as the wifi driver: `scripts/config
--module TUN`, an incremental rebuild of the already-built `-wifi` kernel
tree (fast, since only one config option changed), `modules_install`, then
`modprobe tun` to load it immediately without a reboot.
