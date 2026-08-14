#!/bin/bash
#
# SurimaOS build: 9.6. Configuring the Linux Console
# Run INSIDE chroot. Usage: ./03-console.sh [--force]
#
# DECISION: KEYMAP left unset (defaults to "us"). FONT set to
# Lat2-Terminus16, the book's recommended font for compatibility with
# the C.UTF-8 console locale (has glyphs for the characters that
# locale actually needs, unlike most other shipped console fonts).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-console"

echo "=== Configuring Linux console ==="

echo FONT=Lat2-Terminus16 > /etc/vconsole.conf

mark_done "09-console"
echo "=== Console configuration complete ==="
