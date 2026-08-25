# 00 - Preparation

## Build environment

I didn't build SurimaOS on its target hardware. The build happened inside a
loop-mounted disk image on a separate machine (an OpenMandriva ROME box I'm
calling "the ThinkCentre"), following the LFS 13.0-systemd book chapter by
chapter. The target, a Dell Latitude 7280, only entered the picture once the
build was ready to deploy and boot for real.

Building on one machine and deploying to another isn't how the LFS book
assumes you'll work. See `05-bootloader-and-boot.md` for what that cost me.

## Early decisions

- Init system: systemd, no alternative considered.
- Package manager: planned as a minimal RPM stack for a dnf-like experience.
  Changed later, see `07-package-manager.md`.
- Desktop environment: XFCE (not built yet as of these notes).
- Name: SurimaOS, drawing on the Shurima/Azir theme from League of Legends
  without using the character name directly.

## Remote access

I put all three machines in this project (the ThinkCentre build host, a
laptop I use as a daily driver and remote terminal, and the 7280 target) on
the same Tailscale tailnet early, before the target hardware could even
boot. That let me SSH between machines regardless of where I physically was.

One gotcha: systemd-logind's KillUserProcesses setting tears down an entire
user session, tmux included, if the SSH connection times out (not just
disconnects cleanly, an actual timeout). Killed a multi-hour backup job
mid-transfer. Fixed per-user with `loginctl enable-linger <user>`, and later
set `KillUserProcesses=no` as a default in logind.conf on SurimaOS itself.
