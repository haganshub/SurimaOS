#!/bin/bash
#
# SurimaOS build: 7.3. Preparing Virtual Kernel File Systems
#
# IMPORTANT: Run manually as root, with $LFS exported (sudo -i does
# NOT inherit the lfs user's environment, export it fresh each root
# session: export LFS=/mnt/lfs).
#
# IMPORTANT: These mounts do NOT persist across a reboot of the build
# host. Since the ThinkCentre only runs during active build sessions,
# this script must be re-run at the start of every session, before
# re-entering the chroot, if the machine was shut down or restarted
# since the last time these were mounted.
#
# This also bind-mounts the HOST's real /dev into $LFS/dev, that is
# intentional per the book, the chroot shares the host's running
# kernel and device nodes as its one deliberate exception to
# isolation from the host system.

set -e

if [ -z "$LFS" ]; then
  echo "ERROR: \$LFS is not set in root's environment. Run: export LFS=/mnt/lfs"
  exit 1
fi

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Creating virtual filesystem mount points ==="
mkdir -pv $LFS/{dev,proc,sys,run}

echo "=== Bind-mounting host /dev ==="
mount -v --bind /dev $LFS/dev

echo "=== Mounting remaining virtual kernel filesystems ==="
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

echo "=== Handling /dev/shm ==="
if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

echo ""
echo "=== Verifying mounts ==="
findmnt | grep "$LFS" || echo "WARNING: no mounts found under \$LFS, something may have failed above."

echo ""
echo "=== Virtual kernel filesystems mounted. Ready to enter chroot. ==="
