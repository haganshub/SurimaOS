# 07 — Package Manager: Why Not DNF

## The original plan

The project started with a stated goal: a minimal RPM stack, aiming for a
`dnf`-like day-to-day experience, similar to the OpenMandriva systems
already in use for this build's own tooling.

## The discovery that changed the plan

Neither RPM nor DNF is actually documented anywhere in the current BLFS
book. The only "RPM on an LFS-family system" resource that exists is a
third-party project, and it uses a fundamentally different build approach
(container-based staged builds) than this project's direct chroot-and-boot
method. This is the same category of gap hit earlier with `iwd` (see
`04-kernel.md`): an assumption about what a "normal" Linux distro provides
turned out not to match what the actual book documents.

Building RPM + DNF5 unguided would mean assembling a large, genuinely
complex dependency chain (DNF5 alone pulls in C++, Python, and Ruby
tooling) with no vetted, version-pinned reference to follow, a much
higher-risk undertaking than anything else in this project up to that
point.

## What actually got built instead: pacman

After weighing the tradeoffs directly, the decision was to build `pacman`
(Arch Linux's package manager) instead. It gives genuine dependency
resolution and a real local package database, the actual comfort being
asked for, with a meaningfully smaller and simpler dependency chain than
DNF's.

**Important limitation, worth stating plainly:** this does *not* give
access to Arch's real package repositories. Arch's actual `.pkg.tar.zst`
files are compiled against Arch's own exact library versions and would hit
the same binary-incompatibility wall that already ruled out copying
compiled binaries from any other distro onto this system (see the general
principle in `06-networking-and-remote-access.md` about why software can't
just be copied between differently-built systems). What `pacman` provides
here is a real, local, dependency-tracked package manager for software
*built from source on this system*, not a shortcut to prebuilt Arch
packages.

## Build chain

Three genuinely BLFS-documented dependencies, no drama:

- `libarchive-3.8.5`
- `libpsl-0.21.5`
- `curl-8.18.0`

Then two genuinely unguided builds, no BLFS page for either:

- **`pacman` v7.0.0** — built from Arch's own official source via `meson`,
  with `crypto=openssl`, `curl=enabled`, and `gpgme`/`doc`/`file-seccomp`
  all disabled to keep scope minimal for a first build. Compiled cleanly
  first try (291/291 targets).
- **`fakeroot` 2.1.4** — required by `makepkg` (pacman's package-building
  helper) to let an unprivileged user build packages containing root-owned
  files. Also `meson`-based, no autotools bootstrap needed. Version
  discovered by checking Debian's actual current package pool listing
  directly, rather than trusting an out-of-date search result that pointed
  at a version already superseded upstream.

## Setting up a real local repository

Since there's no upstream repo to point at, a local file-based repo was
created and registered in `/etc/pacman.conf`:

```
[surima]
SigLevel = Never
Server = file:///srv/surima-repo
```

`SigLevel = Never` (not the more common `Optional TrustAll`) is
deliberate: `gpgme` was disabled at build time, so this `pacman` binary
has no signature-verification code compiled in at all, not just a lenient
trust policy. `Optional TrustAll` still assumes some signature machinery
exists to be lenient about, and fails to parse without it.

## Proving the full loop

A real `PKGBUILD` was written for `nano` (a package already built manually
earlier in the project), built with `makepkg -s` as the regular user
(`makepkg` correctly refuses to run as root), added to the local repo with
`repo-add`, and installed with `pacman -S nano`.

This correctly caught a real conflict on the first attempt: the manually-
built `nano` files already existed on disk from earlier in the project,
outside pacman's tracking, and pacman refused to silently overwrite them.
That's the intended safety behavior. Resolved with `pacman -S nano
--overwrite '*'` to have pacman adopt the existing files, after which
`pacman -Qi nano` showed genuine, correct package metadata.

## Personalization

A thin wrapper script, `/usr/local/bin/sos`, exec's straight through to
`pacman`. `sos` was chosen after trying a handful of options: short, easy
to type, and a small pun (SurimaOS initials + the actual word "sos"). The
underlying `pacman` binary and its own config/docs are left completely
untouched, only the day-to-day command name is personalized.
