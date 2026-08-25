#!/bin/bash
#
# Shared setup for SurimaOS Xorg build scripts (BLFS Chapter 24 onward).
#
# Unlike scripts/08-system, 09-config, and 10-boot, this chain runs
# directly on the deployed SurimaOS system (the 7280), not inside the
# old chroot build environment. No $LFS, no /sources, no chroot mount
# setup needed here.
#
# Usage: source this from each numbered script, then call skip_if_done
# and mark_done around the actual work.

set -e

MARKER_DIR="/root/.markers"
mkdir -p "$MARKER_DIR"

skip_if_done() {
  local name="$1"
  if [ -f "$MARKER_DIR/$name.done" ] && [ "$2" != "--force" ]; then
    echo "=== $name already done, skipping (use --force to redo) ==="
    exit 0
  fi
}

mark_done() {
  local name="$1"
  touch "$MARKER_DIR/$name.done"
}

# Make sure the Xorg build environment variables are available even if
# this script is run in a fresh shell that hasn't sourced the profile yet.
if [ -z "$XORG_PREFIX" ] && [ -f /etc/profile.d/xorg.sh ]; then
  source /etc/profile.d/xorg.sh
fi

if [ -z "$XORG_PREFIX" ]; then
  echo "ERROR: XORG_PREFIX is not set and /etc/profile.d/xorg.sh didn't set it."
  echo "Run the Xorg build environment setup first (BLFS x/xorg7.html)."
  exit 1
fi
