#!/bin/bash
#
# SurimaOS build: 9.9. Creating the /etc/shells File
# Run INSIDE chroot. Usage: ./06-shells.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-shells"

echo "=== Creating /etc/shells ==="

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

mark_done "09-shells"
echo "=== /etc/shells complete ==="
