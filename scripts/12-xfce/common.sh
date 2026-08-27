#!/bin/bash
#
# Shared setup for SurimaOS XFCE build scripts (BLFS Chapter 25 onward,
# leading into Chapter 35).
#
# Same pattern as scripts/11-xorg/common.sh. Runs directly on the
# deployed SurimaOS system, no chroot, no $LFS.

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

if [ -z "$XORG_PREFIX" ] && [ -f /etc/profile.d/xorg.sh ]; then
  source /etc/profile.d/xorg.sh
fi
