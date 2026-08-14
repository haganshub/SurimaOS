#!/bin/bash
#
# SurimaOS build: 10.3. Linux-6.18.10 (Part 1 of 2)
# Run INSIDE chroot. Usage: ./01-kernel-part1.sh [--force]
#
# This script extracts the kernel, cleans the tree, and runs
# `make defconfig` as a sane baseline (the book's own recommended
# starting point). It STOPS after that, menuconfig is a genuinely
# interactive curses UI that has to be run by hand, not scripted.
#
# After this script finishes, run `make menuconfig` yourself (see the
# checklist we're tracking separately), then run
# 02-kernel-part2.sh to compile, install, and finish the job.
#
# CONFIRMED FOR TARGET HARDWARE (Latitude 7280):
#   - NVMe storage (CONFIG_BLK_DEV_NVME), NOT SATA
#   - UEFI vs Legacy BIOS: TBD, confirm before finishing menuconfig

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "10-kernel-part1"

echo "=== Kernel Part 1: extract, clean, defconfig baseline ==="

cd /sources
rm -rf linux-6.18.10
tar xf linux-6.18.10.tar.xz
cd linux-6.18.10

make mrproper

make defconfig

echo ""
echo "=== defconfig baseline applied. Kernel source is ready at"
echo "=== /sources/linux-6.18.10 for interactive menuconfig. ==="
echo ""
echo "=== NEXT STEP (manual, not scripted): run 'make menuconfig'"
echo "=== from /sources/linux-6.18.10, work through the checklist,"
echo "=== save and exit, then run 02-kernel-part2.sh. ==="

mark_done "10-kernel-part1"
