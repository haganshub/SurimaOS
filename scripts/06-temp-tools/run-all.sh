#!/bin/bash
#
# SurimaOS build: runs every numbered package script in this folder,
# in order. Safe to re-run any time, already-completed packages are
# skipped via their markers.
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
  "$script" $FORCE_ARG
done

echo ""
echo "=== All package scripts complete ==="
