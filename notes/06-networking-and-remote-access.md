# 06 - Networking, SSH, sudo, and Remote Access

## The bootstrap problem: no network tools at all

Nothing in the core LFS book chapters needs `wget`, `curl`, or `ssh`, so
none were built. The first time any of this mattered was needing to fetch
a source tarball onto the newly-booted system: there was no way to
download anything. Bootstrapped with a single one-time USB transfer of
`wget`'s own source tarball; every download after `wget` itself was built
happened over the network with no further USB involvement.

`wget` alone isn't enough for trustworthy HTTPS, though: with no CA
certificate store, every HTTPS request fails verification. The real fix
was a three-package chain: `libtasn1` → `p11-kit` → `make-ca`, ending with
a real, working Mozilla trust store (516 real certificates) and `wget`
working cleanly with no `--no-check-certificate` flag needed.

## OpenSSH and the first non-root user

Setting up `sshd` per the book's guidance (`PermitRootLogin no` is the
recommended default) requires a working non-root login *first*, otherwise
you lock yourself out. The non-root user (with `wheel` group membership
for future `sudo` use) was created as part of this same step, before
disabling root SSH login, specifically to avoid a chicken-and-egg lockout.

## sudo: a genuine syntax error, caught by sudo's own parser

The intended sudoers rule:

```
%wheel ALL=(ALL) ALL
```

got mangled in transit (likely a copy/paste or heredoc quirk) into
`%wheelALL=(ALL) ALL`, one missing space collapsing two fields into one.
`sudo`'s own parser refused to load the broken file and reported the exact
line and character, which is what caught it. Re-verified the fix with
`visudo` afterward rather than trusting a second manual edit.

## Getting stuck in `vi` and switching the default editor

An earlier session got stuck in `vi`'s modal editing with no prior
familiarity with it. `nano` was built specifically to fix this
(`export EDITOR=nano` in the shell profile), and `visudo` and other
`$EDITOR`-respecting tools now open in nano by default.

## Wifi: multi-network wpa_supplicant config

Once the wifi driver itself worked (see `04-kernel.md`), connecting to an
actual network needed `wpa_supplicant` (BLFS does not document `iwd`, see
the kernel notes for that discovery) plus a DHCP config extension for
`wl*`-named interfaces.

Two real gotchas found while actually using this day to day:

- **The wifi interface doesn't bring itself up on boot.** Unlike the wired
  interface, `wlp2s0` starts in `state DOWN` every boot and needs `ip link
  set wlp2s0 up` run manually before `wpa_supplicant` can do anything.
  Not yet fixed permanently (a `systemd-networkd` `.link` rule would be the
  right fix), currently a one-line manual step.
- **Multiple networks work by just adding more `network={}` blocks** to
  the same `wpa_supplicant` config file. `wpa_supplicant` picks whichever
  is actually in range automatically; no need to switch configs manually
  between locations.
- **SSIDs with spaces need quoting.** `wpa_passphrase MyWifiName` with an
  unquoted SSID containing a space gets parsed as two separate arguments,
  producing a confusing "passphrase too short" error against the wrong
  fragment of the SSID, not a real password-length problem.

## Guest wifi client isolation, and why Tailscale exists in this build

While at a location with guest wifi, direct local-network SSH between
machines was completely blocked, standard guest-network client isolation.
This is the actual motivating reason Tailscale was added at all: its
tunneled-over-the-internet architecture sidesteps local network isolation
policies entirely, rather than needing an actual site-to-site network
route.

Tailscale has no BLFS page and, like most software, its standard one-line
installer script assumes a package manager (`apt`/`dnf`/etc.) that doesn't
exist on this system. It was installed instead via Tailscale's own
official static-binary tarball (`tailscale_<version>_amd64.tgz`), which
ships the `tailscale`/`tailscaled` binaries plus systemd unit files
directly, no package manager needed. Installing it surfaced the
`CONFIG_TUN` kernel gap documented in `04-kernel.md`.

## A safety pause worth documenting

Mid-session, realized a build/config machine was still connected to a
**work** network rather than a private one, right as SSH login testing
was about to happen. Paused before actually initiating an inbound
connection test (which would have created a distinctive, actively-
initiated connection pattern between personal devices on monitored
infrastructure) and did a clean shutdown instead, resuming properly later
on a private network. Worth building this kind of pause into any similar
project: what's benign on your own network can look different on someone
else's monitored one, and it costs nothing to wait.
