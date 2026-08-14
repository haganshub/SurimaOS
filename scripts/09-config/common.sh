#!/bin/bash
#
# SurimaOS build: shared setup, sourced by every numbered package script
# in this folder (Chapter 9, System Configuration).
# Do not run this file directly.
#
# IMPORTANT: unlike Chapters 5/6, these scripts run INSIDE chroot.
# There is no $LFS here, / IS the SurimaOS filesystem. No lfs user
# either, everything runs as root. The chroot environment already has
# MAKEFLAGS="-j$(nproc)" and TESTSUITEFLAGS set globally (from the
# chroot entry command in Chapter 7), so plain "make" already builds
# in parallel, no need to pass -j explicitly, matching the book.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

if [ ! -d /sources ]; then
  echo "ERROR: /sources not found. Are you actually inside the chroot environment?"
  exit 1
fi

# Same marker directory as Chapters 5/6 used (that was $LFS/sources,
# which from inside chroot IS /sources, same physical location).
MARKER_DIR="/sources/.markers"
mkdir -p "$MARKER_DIR"

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
