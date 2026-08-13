#!/bin/bash
#
# SurimaOS build: runs every numbered package script in this folder,
# in order. Run this INSIDE chroot, as root. Safe to re-run any time,
# already-completed packages are skipped via their markers, and it
# stops immediately if any package fails rather than continuing past
# a broken build.
#
# Usage: ./run-all.sh          (skip completed packages)
#        ./run-all.sh --force  (rebuild everything, ignore markers)

DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE_ARG=""
if [ "$1" == "--force" ]; then
  FORCE_ARG="--force"
fi

for script in "$DIR"/[0-9][0-9]-*.sh; do
  echo ""
  echo ">>> Running $(basename "$script")"
  if ! "$script" $FORCE_ARG; then
    echo ""
    echo "!!! $(basename "$script") FAILED. Stopping here, not running further packages."
    echo "!!! Fix the error above, then re-run ./run-all.sh to resume from this package."
    exit 1
  fi
done

echo ""
echo "=== All package scripts complete ==="
