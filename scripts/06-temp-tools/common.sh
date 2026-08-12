#!/bin/bash
#
# SurimaOS build: shared setup, sourced by every numbered package script
# in this folder (Chapter 6, Cross Compiling Temporary Tools).
# Do not run this file directly.

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
# Shared marker directory across chapters, filenames are already
# chapter-prefixed (06-m4, 06-ncurses, etc.) so there's no collision
# risk with the Chapter 5 markers.
MARKER_DIR="$LFS/sources/.markers"
mkdir -p "$MARKER_DIR"

# Same idempotent directory-layout guard as Chapter 5's common.sh.
# Cheap, harmless if already correct, and keeps this folder
# self-sufficient even if run out of order relative to Chapter 5.
mkdir -pv "$LFS"/{etc,var} "$LFS"/usr/{bin,lib,sbin,include}
for i in bin lib sbin; do
  if [ ! -e "$LFS/$i" ]; then
    ln -sv "usr/$i" "$LFS/$i"
  fi
done
case $(uname -m) in
  x86_64) mkdir -pv "$LFS/lib64" ;;
esac

mark_done() {
  touch "$MARKER_DIR/$1.done"
}

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
