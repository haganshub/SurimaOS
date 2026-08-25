#!/bin/bash
#
# Runs every numbered script in this directory in order, stopping on the
# first failure. Usage: ./run-all.sh

set -e
cd "$(dirname "$0")"

for script in [0-9][0-9]-*.sh; do
  echo ""
  echo ">>> Running $script"
  bash "$script"
done

echo ""
echo "=== All package scripts complete ==="
