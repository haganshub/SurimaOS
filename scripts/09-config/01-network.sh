#!/bin/bash
#
# SurimaOS build: 9.2. General Network Configuration
# Run INSIDE chroot. Usage: ./01-network.sh [--force]
#
# DECISIONS (flag to reconsider if wrong):
#   - Hostname: surimaos
#   - DHCP, not static IP (target hardware is a laptop, moves networks)
#   - Predictable interface naming kept as-is (no eth0-style override)
#   - No static /etc/resolv.conf, systemd-resolved handles it on real
#     boot. We don't need chroot internet access right now.
#   - FQDN: localhost.localdomain (book-sanctioned default for a
#     non-internet-facing personal machine)
#   - Wireless networking (wifi on the 7280) is NOT covered here, it's
#     BLFS scope (iwd or wpa_supplicant). This only sets up wired DHCP.
#
# NOTE: this intentionally REPLACES the simpler /etc/hosts written
# back in Chapter 7. Since the myhostname NSS module was configured
# in Chapter 8 (Glibc's nsswitch.conf), /etc/hosts no longer needs a
# 127.0.0.1 localhost line at all, that resolution happens dynamically
# through nsswitch now. This is correct, not a conflict.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-network"

echo "=== Configuring networking ==="

mkdir -pv /etc/systemd/network

cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=en*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

echo "surimaos" > /etc/hostname

cat > /etc/hosts << "EOF"
# Begin /etc/hosts

::1       ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

mark_done "09-network"
echo "=== Network configuration complete ==="
echo ""
echo "=== Reminder: wireless (wifi) setup for the 7280 is BLFS scope,"
echo "=== not covered here. Revisit once testing on real hardware. ==="
