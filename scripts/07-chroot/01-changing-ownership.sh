#!/bin/bash
#
# SurimaOS build: 7.2. Changing Ownership
#
# IMPORTANT: This is NOT run via run-all.sh like Chapters 5/6. This
# must be run manually, as root, with $LFS already exported in root's
# shell (it is NOT inherited from the lfs user's environment).
#
# How to run this script:
#   sudo -i
#   export LFS=/mnt/lfs
#   bash /path/to/this/script.sh
#
# Or just run the commands below directly, they're short enough.

set -e

if [ -z "$LFS" ]; then
  echo "ERROR: \$LFS is not set in root's environment. Run: export LFS=/mnt/lfs"
  exit 1
fi

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Changing ownership of \$LFS to root:root ==="

chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac

echo "=== Ownership change complete ==="
