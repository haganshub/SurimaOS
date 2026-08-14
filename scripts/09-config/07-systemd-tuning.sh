#!/bin/bash
#
# SurimaOS build: 9.10. Systemd Usage and Configuration (selected items)
# Run INSIDE chroot. Usage: ./07-systemd-tuning.sh [--force]
#
# Most of 9.10 is reference material for later administration
# (journalctl, coredumpctl, systemctl usage), nothing to configure
# now. Two things ARE worth setting proactively:
#
# 1. KillUserProcesses=no in logind.conf. This is the system-wide fix
#    for the EXACT problem that killed our Chapter 8 backup tmux
#    session on an SSH timeout (systemd tearing down connor's whole
#    session scope, tmux included, mid-backup). We worked around it
#    per-user with `loginctl enable-linger connor` on the ThinkCentre,
#    but baking the system-wide fix into SurimaOS itself means future
#    users of the actual built OS don't have to rediscover this the
#    hard way. DECISION: applying this by default.
#
# 2. Disabling screen-clear at boot. Cosmetic preference, fits a
#    hands-on/homelab style where seeing boot messages is useful.
#    DECISION: applying this by default, trivial to revert if you'd
#    rather have a clean boot screen (just delete the noclear.conf
#    drop-in this creates).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-systemd-tuning"

echo "=== Applying selected systemd tuning ==="

echo "--- Setting KillUserProcesses=no in logind.conf (system-wide fix"
echo "--- for the session-kill issue we hit during the Chapter 8 backup) ---"
if grep -q "^KillUserProcesses=" /etc/systemd/logind.conf 2>/dev/null; then
  sed -i 's/^KillUserProcesses=.*/KillUserProcesses=no/' /etc/systemd/logind.conf
elif grep -q "^#KillUserProcesses=" /etc/systemd/logind.conf 2>/dev/null; then
  sed -i 's/^#KillUserProcesses=.*/KillUserProcesses=no/' /etc/systemd/logind.conf
else
  echo "KillUserProcesses=no" >> /etc/systemd/logind.conf
fi
grep "KillUserProcesses" /etc/systemd/logind.conf

echo ""
echo "--- Disabling screen clear at boot (cosmetic preference) ---"
mkdir -pv /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

mark_done "09-systemd-tuning"
echo "=== Systemd tuning complete ==="
echo ""
echo "=== That closes out Chapter 9 (System Configuration). ==="
echo "=== Next: Chapter 10, Making the LFS System Bootable. ==="
