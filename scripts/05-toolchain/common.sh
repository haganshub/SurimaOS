#!/bin/bash
#
# SurimaOS build: shared setup, sourced by every numbered package script
# in this folder. Do not run this file directly.

set -e

if [ -z "$LFS" ]; then
  echo "ERROR: \$LFS is not set. Source your .bash_profile as the lfs user first."
  exit 1
fi

if [ "$(whoami)" != "lfs" ]; then
  echo "ERROR: this must be run as the 'lfs' user, currently running as $(whoami)."
  exit 1
fi

JOBS=$(nproc)
MARKER_DIR="$LFS/sources/.markers"
mkdir -p "$MARKER_DIR"

# LFS Chapter 4.2, "Creating a Limited Directory Layout". This has to
# exist before ANY Chapter 5 package runs (Glibc in particular needs
# $LFS/lib64 and $LFS/usr/include to already be real directories, not
# something cp/ln creates implicitly on the fly). Run unconditionally,
# every script invocation, it's cheap and fully idempotent, so no
# script in this folder can ever again run before this layout exists.
mkdir -pv "$LFS"/{etc,var} "$LFS"/usr/{bin,lib,sbin,include}
for i in bin lib sbin; do
  if [ ! -e "$LFS/$i" ]; then
    ln -sv "usr/$i" "$LFS/$i"
  fi
done
case $(uname -m) in
  x86_64) mkdir -pv "$LFS/lib64" ;;
esac

# Call this at the very end of a package script, once install succeeds.
mark_done() {
  touch "$MARKER_DIR/$1.done"
}

# Call this at the top of a package script. If the package already has
# a completion marker, the script exits 0 immediately instead of
# redoing work. Pass --force as an argument to the package script to
# rebuild anyway.
skip_if_done() {
  if [ -f "$MARKER_DIR/$1.done" ] && [ "$FORCE" != "1" ]; then
    echo "SKIP: $1 already completed (marker found). Use --force to rebuild."
    exit 0
  fi
}

FORCE=0
if [ "$2" == "--force" ] || [ "$1" == "--force" ]; then
  FORCE=1
fi
