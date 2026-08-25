# 03 - Base System Build (LFS Chapter 8)

Largest chapter in the book by far, 81 packages, more than double Chapters
5-7 combined. Most of it built clean by following the book. This file only
covers the actual deviations and bugs.

## Vim, downloaded on its own

Vim's version moves too fast to pin in a static manifest, so I left it out
and downloaded it inline from its own build script, with the version and
MD5 pulled from the book's package list at build time:

```bash
VIM_VERSION="9.2.0078"
VIM_URL="https://github.com/vim/vim/archive/v${VIM_VERSION}/vim-${VIM_VERSION}.tar.gz"
VIM_MD5="592819d17a5f76d39ddba5651912afe0"
```

Fails loudly if the checksum doesn't match, in case the version's moved on.

## Procps-ng test suite bug

The book warns one ps test (bsdtime,cputime,etime,etimes flags) fails if
the host kernel lacks CONFIG_BSD_PROCESS_ACCT. Every other package with a
flagged expected failure had its test suite wrapped in set +e / set -e so
that didn't kill the batch. I wrote procps-ng's script without the
wrapper, so the exact test the book warned about took the whole run down.
Fixed it the same way the others were handled, then double-checked with
grep instead of just assuming it took.

## Cleanup script and rm -rf /tmp

The book's cleanup step runs `rm -rf /tmp/{*,.*}`. GNU rm refuses to
remove `.` and `..`, which the `.*` glob matches, and exits non-zero. Under
set -e that kills the script right at the end. Fixed with `|| true`.

## Stripping deferred

LFS 8.85 (stripping debug symbols) carries a real warning: get it wrong on
a system that hasn't booted yet and you can brick it. Skipped it and
pushed to after the first real boot on hardware. Still optional, worth
about 2GB, low priority.

## Backup

15-20+ hours of cumulative build time by the end of this chapter, so I took
a full tar backup and verified it before moving on. First attempt got lost
mid-transfer to the KillUserProcesses bug from `00-preparation.md`, second
attempt worked after enabling lingering.
