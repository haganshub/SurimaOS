#!/bin/bash
#
# BLFS Systemd Units package: install the real lightdm.service unit
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./48-lightdm-service.sh [--force]
#
# This package holds every BLFS systemd unit file used throughout the
# book. Each unit has its own install target (make install-<unit>),
# which installs the file to the right place AND enables it, so
# lightdm should actually start on boot once this runs.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-lightdm-service" "$1"

echo "=== Installing the real lightdm.service systemd unit ==="

cd /root/src
rm -rf blfs-systemd-units-20251204
wget https://www.linuxfromscratch.org/blfs/downloads/13.0-systemd/blfs-systemd-units-20251204.tar.xz
tar xf blfs-systemd-units-20251204.tar.xz
cd blfs-systemd-units-20251204

make install-lightdm

mark_done "12-lightdm-service"
echo "=== lightdm.service installed and enabled ==="
echo ""
echo "=== That's the full display manager chain done: lightdm,"
echo "=== the greeter, and the real systemd unit. This is the real"
echo "=== moment: a reboot should now bring up a graphical login. ==="
