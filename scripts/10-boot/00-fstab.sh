#!/bin/bash
#
# SurimaOS build: 10.2. Creating the /etc/fstab File
# Run INSIDE chroot. Usage: ./00-fstab.sh [--force]
#
# IMPORTANT CAVEAT: this fstab is written for the PLANNED partition
# scheme on the Latitude 7280 (the actual deployment target), not the
# ThinkCentre we're building on. We are not physically on the 7280
# right now, so these device names are a plan, not yet a verified
# fact. Before this fstab can be trusted for a real install, Phase 9
# (real install onto the 7280) must:
#   1. Physically partition the 7280 to match this scheme
#   2. Confirm the actual device names match what's assumed here
#   3. Adjust this file if anything differs
#
# PLANNED SCHEME (256GB NVMe, single drive /dev/nvme0n1):
#   /dev/nvme0n1p1  1GB     FAT32 (ESP)   /boot/efi
#   /dev/nvme0n1p2  8GB     swap          swap
#   /dev/nvme0n1p3  ~247GB  ext4          /
#
# This is specific to the 7280. If SurimaOS is ever installed on a
# different device later, that device gets its own partitioning and
# its own fstab at that time, this file does not carry over.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "10-fstab"

echo "=== Creating /etc/fstab (planned scheme for Latitude 7280, TBD-verified) ==="

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system         mount-point   type    options        dump  fsck
#                                                                 order

/dev/nvme0n1p3        /             ext4    defaults       1     1
/dev/nvme0n1p1        /boot/efi     vfat    umask=0077      1     2
/dev/nvme0n1p2        swap          swap    pri=1           0     0

# End /etc/fstab
EOF

mark_done "10-fstab"
echo "=== fstab complete (provisional, verify against actual 7280 partitions in Phase 9) ==="
