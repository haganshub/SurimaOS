#!/bin/bash
#
# SurimaOS build: 9.5. Configuring the System Clock
# Run INSIDE chroot. Usage: ./02-clock.sh [--force]
#
# DECISION: hardware clock set to UTC, not local time. This is the
# modern standard default. Per the book, if /etc/adjtime is absent at
# first boot, systemd-timedated assumes UTC automatically, so the
# correct action for choosing UTC is deliberately NOT creating that
# file, not an oversight.
#
# NOTE: timedatectl doesn't work inside chroot, only after a real
# systemd boot. Nothing to run here beyond documenting the decision.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "09-clock"

echo "=== System clock: UTC selected (no /etc/adjtime created, this is intentional) ==="

mark_done "09-clock"
echo "=== Clock configuration complete ==="
