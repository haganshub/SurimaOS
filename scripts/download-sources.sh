#!/bin/bash
#
# SurimaOS build script: download and verify all LFS source packages
# Run this as the 'lfs' user, with $LFS already set.
#
# Reads scripts/sources-manifest.txt (URL|MD5 per line) and downloads
# each tarball into $LFS/sources, then verifies its MD5 checksum.
# Safe to re-run: skips files already downloaded and verified.

set -e

if [ -z "$LFS" ]; then
  echo "ERROR: \$LFS is not set. Source your .bash_profile as the lfs user first."
  exit 1
fi

MANIFEST="$(cd "$(dirname "$0")" && pwd)/sources-manifest.txt"

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: manifest not found at $MANIFEST"
  exit 1
fi

# Per the LFS book: sources dir should be owned by lfs:lfs with the
# sticky bit set, so multiple users (later, root during the actual
# build) can write to it safely.
mkdir -pv "$LFS/sources"
chmod -v a+wt "$LFS/sources"

cd "$LFS/sources"

FAILED=()

while IFS='|' read -r url expected_md5; do
  # skip blank lines and comments
  [[ -z "$url" || "$url" == \#* ]] && continue

  filename=$(basename "$url")

  if [ -f "$filename" ]; then
    actual_md5=$(md5sum "$filename" | awk '{print $1}')
    if [ "$actual_md5" == "$expected_md5" ]; then
      echo "OK (already present, verified): $filename"
      continue
    else
      echo "WARNING: $filename exists but checksum mismatch, re-downloading"
      rm -f "$filename"
    fi
  fi

  echo "Downloading: $filename"
  if ! wget -q --show-progress "$url" -O "$filename"; then
    echo "ERROR: failed to download $filename from $url"
    FAILED+=("$filename")
    continue
  fi

  actual_md5=$(md5sum "$filename" | awk '{print $1}')
  if [ "$actual_md5" != "$expected_md5" ]; then
    echo "ERROR: checksum mismatch for $filename (expected $expected_md5, got $actual_md5)"
    FAILED+=("$filename")
  else
    echo "OK: $filename verified"
  fi

done < "$MANIFEST"

echo ""
echo "=== Vim note ==="
echo "Vim is intentionally not in the manifest, its version changes"
echo "frequently and the book points to https://github.com/vim/vim/tags"
echo "for the current release. Download it manually when you reach"
echo "Chapter 8/BLFS and add its checksum by hand at that point."
echo ""

if [ ${#FAILED[@]} -ne 0 ]; then
  echo "=== ${#FAILED[@]} package(s) failed download or verification: ==="
  printf '  %s\n' "${FAILED[@]}"
  exit 1
else
  echo "All packages downloaded and verified successfully."
fi
