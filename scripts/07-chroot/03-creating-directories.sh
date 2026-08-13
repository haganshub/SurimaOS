#!/bin/bash
#
# SurimaOS build: 7.5. Creating Directories
#
# IMPORTANT: Run this INSIDE the chroot environment, as root. There is
# no $LFS variable inside chroot, / IS the SurimaOS filesystem now.
# This is not run via a marker/skip pattern like Chapters 5/6, it's
# safe to re-run (mkdir -p and ln -sfv are both idempotent), so no
# marker tracking needed here.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Creating FHS directory structure ==="

mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

echo ""
echo "=== Sanity check: /usr/lib64 must NOT exist ==="
if [ -e /usr/lib64 ]; then
  echo "WARNING: /usr/lib64 exists! Per the book, this directory must not"
  echo "be present, its existence can break later build steps. Investigate"
  echo "what created it before continuing."
else
  echo "OK: /usr/lib64 does not exist, as expected."
fi

echo ""
echo "=== Directory structure complete ==="
