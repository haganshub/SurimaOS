#!/bin/bash
#
# SurimaOS build: kernel config fixup, using scripts/config for
# deterministic, non-interactive editing of .config. This exists
# because manual menuconfig navigation reverted CONFIG_BLK_DEV_NVME
# and CONFIG_IRQ_REMAP after an accidental exit. Safe to re-run any
# time, every command here is idempotent.
#
# Run from /sources/linux-6.18.10, as root, inside chroot.
# Usage: ./config-fixup.sh

set -e

cd /sources/linux-6.18.10

if [ ! -f .config ]; then
  echo "ERROR: no .config found. Run 01-kernel-part1.sh first."
  exit 1
fi

echo "=== Force-setting all checklist items via scripts/config ==="

./scripts/config --disable WERROR
./scripts/config --enable  PSI
./scripts/config --disable PSI_DEFAULT_DISABLED
./scripts/config --disable IKHEADERS
./scripts/config --enable  CGROUPS
./scripts/config --enable  MEMCG
./scripts/config --enable  CGROUP_SCHED
./scripts/config --disable RT_GROUP_SCHED
./scripts/config --disable EXPERT
./scripts/config --enable  RELOCATABLE
./scripts/config --enable  RANDOMIZE_BASE
./scripts/config --enable  STACKPROTECTOR
./scripts/config --enable  STACKPROTECTOR_STRONG
./scripts/config --enable  NET
./scripts/config --enable  INET
./scripts/config --enable  IPV6
./scripts/config --disable UEVENT_HELPER
./scripts/config --enable  DEVTMPFS
./scripts/config --enable  DEVTMPFS_MOUNT
./scripts/config --enable  FW_LOADER
./scripts/config --disable FW_LOADER_USER_HELPER
./scripts/config --enable  DMIID
./scripts/config --enable  SYSFB_SIMPLEFB
./scripts/config --enable  DRM
./scripts/config --enable  DRM_PANIC
./scripts/config --set-str DRM_PANIC_SCREEN "kmsg"
./scripts/config --enable  DRM_FBDEV_EMULATION
./scripts/config --enable  DRM_SIMPLEDRM
./scripts/config --enable  FRAMEBUFFER_CONSOLE
./scripts/config --enable  INOTIFY_USER
./scripts/config --enable  TMPFS
./scripts/config --enable  TMPFS_POSIX_ACL
./scripts/config --enable  PCI
./scripts/config --enable  PCI_MSI
./scripts/config --enable  IOMMU_SUPPORT
./scripts/config --enable  IRQ_REMAP
./scripts/config --enable  X86_X2APIC
./scripts/config --enable  BLK_DEV_NVME
./scripts/config --enable  EXT4_FS
./scripts/config --enable  VFAT_FS
./scripts/config --enable  MSDOS_FS

echo ""
echo "=== Resolving any newly-exposed dependencies non-interactively ==="
make olddefconfig

echo ""
echo "=== Final verification ==="
grep -E "^CONFIG_BLK_DEV_NVME|^CONFIG_X86_X2APIC|^CONFIG_PCI_MSI|^CONFIG_IRQ_REMAP|^CONFIG_DRM_SIMPLEDRM|^CONFIG_FRAMEBUFFER_CONSOLE|^CONFIG_DRM=|^CONFIG_DEVTMPFS=|^CONFIG_DEVTMPFS_MOUNT|^CONFIG_IPV6=|^CONFIG_TMPFS=|^CONFIG_EXT4_FS=|^CONFIG_VFAT_FS=|^CONFIG_MSDOS_FS=" .config

echo ""
echo "=== All items above should show =y. If anything is missing, paste"
echo "=== this output back for review before proceeding to compile. ==="
