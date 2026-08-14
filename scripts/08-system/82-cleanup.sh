#!/bin/bash
#
# SurimaOS build: 8.86. Cleaning Up
# Run INSIDE chroot. Usage: ./82-cleanup.sh [--force]
#
# NOTE: 8.85 Stripping is deliberately skipped/deferred (Connor's
# decision, revisit once the system boots and is proven stable). This
# script only covers 8.86.
#
# This is the FINAL step of Chapter 8. Once this completes, the
# entire chapter (81 packages plus this cleanup) is done.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-cleanup"

echo "=== Chapter 8 final cleanup ==="

rm -rf /tmp/{*,.*} 2>/dev/null || true

find /usr/lib /usr/libexec -name \*.la -delete

# Remove remnants of the Chapter 6/7 temporary compiler, no longer needed.
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# Remove the temporary test user created back in Chapter 7.
userdel -r tester

mark_done "08-cleanup"
echo "=== Cleanup complete ==="
echo ""
echo "=== CHAPTER 8 (Installing Basic System Software) IS NOW FULLY COMPLETE. ==="
echo "=== 81 packages built. Stripping (8.85) deliberately deferred. ==="
echo "=== Next: Chapter 9, System Configuration. ==="
