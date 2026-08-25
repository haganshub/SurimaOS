# 03 - Base System Build (LFS Chapter 8)

This is the largest chapter in the LFS book by a wide margin, 81 packages,
more than double the combined size of Chapters 5-7. Most packages built
cleanly by following the book exactly. This file only covers the real
deviations and bugs.

## Vim: deliberately excluded from the source manifest

Vim's version changes too frequently to pin in a static download list, so
it was deliberately left out of the initial source manifest and downloaded
inline by its own build script instead, with the exact version and MD5
checksum captured from the book's own package list page at build time:

```bash
VIM_VERSION="9.2.0078"
VIM_URL="https://github.com/vim/vim/archive/v${VIM_VERSION}/vim-${VIM_VERSION}.tar.gz"
VIM_MD5="592819d17a5f76d39ddba5651912afe0"
```

The script downloads, verifies the checksum, and fails loudly with a link
to the vim tags page if the version is ever bumped upstream.

## Procps-ng: a real scripting bug, not a book issue

The book explicitly warns that one `ps` test (`bsdtime,cputime,etime,etimes`
output flags) is expected to fail if the host kernel lacks
`CONFIG_BSD_PROCESS_ACCT`. Every other package with a similarly-flagged
"this test may fail" warning had its test suite wrapped in `set +e` / `set
-e` so a known, expected failure wouldn't abort the whole script under the
project's `set -e` convention. Procps-ng's script was written without that
wrapper, so the very test the book warned about took down the entire batch
run. Fixed by wrapping the test invocation the same way every other
flagged package was already handled, and by re-verifying with `grep` after
the fact that the fix actually reverted correctly (a lesson from a
different bug, see `04-kernel.md`, about not trusting a fix until you've
confirmed it in the actual file).

## Cleanup script: `rm -rf /tmp/{*,.*}` under `set -e`

The book's final cleanup step includes `rm -rf /tmp/{*,.*}`. GNU `rm`
refuses to remove `.` and `..` (which the `.*` glob matches) and exits
non-zero when it hits them. Under this project's `set -e` convention, that
non-zero exit would silently abort the cleanup script right at the finish
line. Fixed with `|| true` on that specific line.

## Stripping (LFS 8.85) deliberately deferred

The book's optional debug-symbol-stripping step carries a real warning:
doing it wrong on a system that isn't yet confirmed to boot can render it
completely unusable. Since this chapter finished before the system had
ever actually booted on real hardware, stripping was deliberately skipped
and pushed to a later checkpoint (after the first successful real boot),
rather than risking an unrecoverable mistake on an unproven build. As of
these notes it's still an optional, low-priority task, worth roughly 2GB.

## Full backup taken after this chapter

Given the size of this chapter (15-20+ hours of cumulative build time), a
full `tar` backup of the entire build tree was taken and integrity-verified
before moving on. The first backup attempt was lost mid-transfer to the
`KillUserProcesses` session-kill bug described in `00-preparation.md`; the
second attempt, after enabling lingering, succeeded.
