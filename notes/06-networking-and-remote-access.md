# 06 - Networking, SSH, sudo, and Remote Access

## No network tools at all, at first

Nothing in the core LFS chapters needs wget, curl, or ssh, so none exist
by default. First time it mattered was needing to fetch a source tarball
onto the freshly-booted system with no way to download anything.
Bootstrapped with one USB transfer of wget's own source; everything after
that came over the network.

wget alone isn't enough for real HTTPS though, no CA store means every
request fails verification. Fixed with a three-package chain: libtasn1,
p11-kit, make-ca, ending with a working Mozilla trust store (516
certificates) and wget working clean with no --no-check-certificate flag.

## OpenSSH and the first non-root user

Setting up sshd per the book (PermitRootLogin no is the recommended
default) needs a working non-root login first, or you lock yourself out.
Created the non-root user (wheel group, for sudo later) as part of this
same step, before disabling root SSH.

## sudo syntax error

Meant to write:

```
%wheel ALL=(ALL) ALL
```

It got mangled somewhere in transit into `%wheelALL=(ALL) ALL`, one
missing space. sudo's own parser refused to load the file and pointed at
the exact line. Re-checked the fix with visudo instead of trusting a
second manual edit.

## Switched off vi

Got stuck in vi's modal editing with no prior familiarity with it at some
point earlier. Built nano and set EDITOR=nano in the shell profile so
visudo and anything else respecting $EDITOR opens in nano now.

## Wifi day to day

Once the driver worked (`04-kernel.md`), actually connecting needed
wpa_supplicant (no iwd, see kernel notes) and a DHCP config extension for
wl*-named interfaces.

A few things worth knowing:

- wlp2s0 doesn't bring itself up on boot. Unlike the wired interface it
  starts in state DOWN every time and needs `ip link set wlp2s0 up`
  before wpa_supplicant can do anything. Not fixed permanently yet, a
  systemd-networkd .link rule would be the right way.
- Multiple networks just means more network={} blocks in the same
  wpa_supplicant config. It picks whichever's in range on its own.
- SSIDs with spaces need quoting. `wpa_passphrase MyWifiName` unquoted
  gets split into two arguments, which produces a confusing "passphrase
  too short" error that has nothing to do with the actual password.

## Guest wifi and why Tailscale is here

At a location with guest wifi, direct SSH between machines on the same
network was completely blocked, standard client isolation. That's the
actual reason Tailscale got added, it tunnels over the internet instead of
needing a direct network route, so local isolation policies don't matter.

No BLFS page for it, and its normal install script assumes a package
manager that doesn't exist here. Installed from Tailscale's own
static-binary tarball instead, ships the binaries and systemd units
directly. Installing it is what surfaced the CONFIG_TUN gap in
`04-kernel.md`.

## Almost SSH'd in on a work network

Mid-session, realized a machine was still on a work network instead of a
private one, right before testing an inbound SSH connection. Held off and
did a clean shutdown instead of running the test, picked it back up later
on a private network. What's fine on your own network can look different
on someone else's monitored one.
