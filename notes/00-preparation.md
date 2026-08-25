# 00 - Preparation

## Build environment

SurimaOS was not built directly on its target hardware. The actual build happened
inside a loop-mounted disk image on a separate machine (an OpenMandriva ROME
"ThinkCentre" box), following the LFS 13.0-systemd book chapter by chapter. The
target hardware, a Dell Latitude 7280, only entered the picture in Phase 9, when
the finished system was transferred over and made to actually boot for real.

This split (build host ≠ target host) is not how the LFS book assumes you'll work,
and it created real friction later, see `05-bootloader-and-boot.md` for the biggest
consequence of that decision.

## Key early decisions

- **Init system:** systemd, no alternative considered.
- **Package manager:** originally planned as a minimal RPM stack for a `dnf`-like
  experience. This changed significantly later, see `07-package-manager.md`.
- **Desktop environment:** XFCE (not yet built as of these notes).
- **Distro name:** SurimaOS, drawing on the Shurima/Azir theme from League of
  Legends without using the character name directly (trademark/IP reasons).

## Remote access setup

All three machines involved in this project (the ThinkCentre build host, a
5530-model OpenMandriva laptop used as a daily driver and remote terminal, and
the Latitude 7280 target) were joined to the same Tailscale tailnet early on,
before the target hardware was even bootable. This made it possible to SSH
between machines regardless of physical location, which mattered a lot once
work started happening across home and other networks.

One early gotcha: `systemd-logind`'s `KillUserProcesses` setting will tear down
an entire user session, tmux included, if the underlying SSH connection times
out (not just a clean disconnect, an actual timeout). This killed a multi-hour
backup job mid-transfer. Fixed per-user with `loginctl enable-linger <user>`,
and later baked into the actual built system itself as a `KillUserProcesses=no`
default in `logind.conf`, so future users of SurimaOS don't hit the same problem.
