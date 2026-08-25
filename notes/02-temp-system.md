# 02 — Temporary System & Chroot (LFS Chapters 6-7)

## Workflow

Scripts were staged in two locations: `/home/lfs/build-scripts/` on the host
side, copied into `/root/scripts/` once inside the chroot. Every package got
its own numbered script, run through a `run-all.sh` runner that stops on the
first failure and tracks completion via marker files in `/sources/.markers/`.

## SSH disconnect kills non-tmux processes

Building GCC/Glibc/etc. takes long enough that an SSH session will often
drop mid-build. Anything not running inside `tmux` dies with the connection.
Lesson learned the hard way on the Glibc backup step (a 2.4GB tar), which
had to be restarted inside tmux on the second attempt. From this point on,
every long-running step in the project ran inside tmux.

## Ownership bug found much later, worth knowing about early

Chapter 7's ownership-fixing step (`chown --from lfs -R root:root
$LFS/{usr,var,etc,tools,lib64}`) only targets those specific named
directories. It does **not** cover the top-level `$LFS` directory itself, or
the `bin`/`sbin`/`lib` symlinks created back in the initial directory setup.
Those four paths silently kept the temporary `lfs` build user's UID/GID
(whatever `useradd` assigned, in this build's case 1002/1007) all the way
through the rest of the build. This wasn't discovered until a real
filesystem ownership audit during the Phase 9 deployment to real hardware
(see `find /mnt/target -uid 1002 -o -gid 1007` catching it).

It's not a security hole (symlink ownership is cosmetic; the kernel checks
the permissions of whatever the symlink points to, not the link itself),
but it's real metadata cleanliness worth fixing at the source. The fix:
after the book's own `chown` command, also run:

```bash
chown -h root:root $LFS $LFS/bin $LFS/sbin $LFS/lib
```

## Chroot entry

Standard LFS chroot entry (`chroot "$LFS" /usr/bin/env -i ...`) worked
without issue once the virtual kernel filesystems (`/dev`, `/dev/pts`,
`/proc`, `/sys`, `/run`) were bind-mounted per the book. These mounts must
be redone every time you re-enter chroot after a reboot or new session,
they don't persist.
