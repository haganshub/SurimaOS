#!/bin/bash
#
# Shared setup for SurimaOS XFCE build scripts (BLFS Chapter 25 onward,
# leading into Chapter 35).
#
# Same pattern as scripts/11-xorg/common.sh. Runs directly on the
# deployed SurimaOS system, no chroot, no $LFS.
#
# STANDING RULE for this whole chapter: GTK3 was built with
# introspection=false (a real dead end, HarfBuzz has no .gir
# generation capability at all, so anything upstream needing a real
# introspection chain hits a wall). Every XFCE component that offers
# an introspection toggle (autotools: --enable-introspection=no,
# meson: -D introspection=disabled or =false depending on whether the
# package uses meson's boolean or feature option type, check the
# error message or meson_options.txt/meson.options if unsure) should
# have it explicitly disabled, rather than waiting for each one to
# fail individually the way libxfce4ui and libwnck both did.

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
