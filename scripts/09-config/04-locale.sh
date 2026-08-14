#!/bin/bash
#
# SurimaOS build: 9.7. Configuring the System Locale
# Run INSIDE chroot. Usage: ./04-locale.sh [--force]
#
# DECISION: en_US.UTF-8, matches location and was already installed
# as part of Chapter 8's Glibc locale list (localedef -i en_US -f
# UTF-8 en_US.UTF-8), so this is already the canonical name, no
# heuristic charmap translation needed like the book's ISO-8859-1
# example.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-locale"

echo "=== Verifying en_US.UTF-8 locale before use ==="

set +e
LC_ALL=en_US.UTF-8 locale language
LC_ALL=en_US.UTF-8 locale charmap
LC_ALL=en_US.UTF-8 locale int_curr_symbol
LC_ALL=en_US.UTF-8 locale int_prefix
LOCALE_CHECK_STATUS=$?
set -e

echo ""
if [ $LOCALE_CHECK_STATUS -ne 0 ]; then
  echo "=== WARNING: one or more locale checks failed (likely a"
  echo "=== 'Cannot set LC_* to default locale' error above). This"
  echo "=== means en_US.UTF-8 wasn't installed correctly back in"
  echo "=== Chapter 8. Investigate before trusting the config below. ==="
else
  echo "=== All four locale checks passed cleanly. ==="
fi
echo ""

echo "=== Configuring system locale ==="

cat > /etc/locale.conf << "EOF"
LANG=en_US.UTF-8
EOF

cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# End /etc/profile
EOF

mark_done "09-locale"
echo "=== Locale configuration complete ==="
