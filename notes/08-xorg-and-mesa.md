# 08 - Xorg and Mesa

## Build environment

Xorg supports installing into an alternate prefix, but the book itself
recommends /usr, and there's no real reason to deviate given every other
package in this project already lives there. Set XORG_PREFIX=/usr and
skipped the whole alternate-prefix section of the book, symlinks,
PKG_CONFIG_PATH tweaks, none of it applies once you're on the standard
prefix.

## Confirmed: Xorg and XFCE are real BLFS chapters

After hitting the iwd and RPM/DNF gaps earlier in this project, I checked
the book's actual table of contents before assuming anything this time.
Both Xorg (Chapter 24) and XFCE (Chapter 35) are actually documented,
real package lists, real versions, no repeat of that surprise.

## No separate GPU driver package needed

BLFS 13.0-systemd has removed the traditional per-vendor Xorg video
drivers (including the old Intel one) in favor of a generic modesetting
driver built directly into Xorg-Server itself, working through the
kernel's DRM/KMS layer. Since i915 was already confirmed working back
during the wifi driver work, this meant one less driver hunt for the
actual 2D/basic display path.

## The straightforward chain

util-macros, xorgproto, libXau, libXdmcp, xcb-proto, libxcb, libxcvt,
xcb-util, and the small XCB Utilities bundle all built cleanly following
the book exactly. FreeType and Fontconfig turned out to be real
dependencies of the 31-package Xorg Libraries bundle that weren't
obvious until the book's own dependency line pointed at them, neither
was a surprise once found, just not something I'd anticipated needing
before starting that bundle.

The Xorg Libraries bundle itself (xtrans, libX11, libXext, and 28 more)
followed the book's own per-package build loop almost exactly, simplified
since this project runs as root throughout, no need for the book's
as_root wrapper function that exists for people building as a regular
user with sudo.

## Mesa: the biggest detour in the project

This is worth its own section. Going in, the plan was to build only the
drivers for our confirmed real hardware (Intel HD 620, Kaby Lake): iris
for OpenGL, no Vulkan, and no llvmpipe backup, specifically to avoid
pulling in LLVM, a 13 SBU build on its own.

Mesa's configure step immediately wanted glslangValidator, which turned
out to be needed regardless of Vulkan being enabled or not, not a
Vulkan-specific requirement like the dependency list implied. That
needed Glslang, which needed CMake (never built anywhere in this project)
and SPIRV-Tools, which needed SPIRV-Headers.

With that chain built, Mesa's configure step then wanted libclc. The
dependency list called this "required for the Intel iris gallium
driver," which read like it might be tied to an optional OpenCL feature
I could disable. It wasn't. Reading Mesa's actual meson.build source
directly showed with_gallium_iris unconditionally sets
with_driver_using_cl to true, no flag disables it. libclc is hardwired
into iris itself, for its internal shader compiler, nothing to do with
end-user OpenCL support.

libclc needs SPIRV-LLVM-Translator, which links against real LLVM
libraries, not just build tooling. At that point the LLVM build I'd
specifically planned to avoid was unavoidable. Decided to build it for
real rather than fall back to a CPU-only softpipe desktop.

LLVM-21.1.8 with Clang took about 13 SBU, the single largest build in
this project, run overnight with nohup after tmux turned out to have
never been built on this system. It survived the whole night untouched.

Two more real gaps turned up finishing the chain: libxml2 (needed by
SPIRV-LLVM-Translator, never built here either) and Git (never built
either, needed only because libxml2's meson build system unconditionally
checks for a git binary even when building from a plain tarball, not an
actual git checkout).

Full chain, in the order it actually had to happen: libdrm, Mako, PyYAML
(Mesa's real listed deps) -> CMake -> SPIRV-Headers -> SPIRV-Tools ->
Glslang -> LLVM-21.1.8 + Clang -> libxml2 -> Git -> SPIRV-LLVM-Translator
-> libclc -> back to Mesa, which finally built clean.

One mistake along the way worth naming: partway through, I guessed at a
meson option name (gallium-opencl) to try to disable the OpenCL
requirement without reading the actual options file first. It doesn't
exist, meson failed immediately with an "unknown option" error. Checked
the real file (it's named meson.options in newer Meson, not
meson_options.txt) and confirmed there's no such flag at all, the
libclc requirement really is unconditional for iris. Lesson already
learned once this project (the wifi driver's kernel config), reinforced
again here: check the real file before assuming a flag exists.

## Verifying Mesa actually built right

Modern Mesa consolidates every Gallium3D driver into one shared library,
libgallium-<version>.so, with small named files like iris_dri.so acting
as symlinks to a shared loader stub rather than standalone driver files.
This looks broken at first glance if you don't know the architecture,
checking file sizes or running file on iris_dri.so shows a tiny symlink,
not a real driver. Confirmed the real driver code actually compiled in
with strings against libgallium itself, looking for Intel-specific
internal symbols (intel_tbimr, GL_INTEL_blackhole_render, and similar),
which only show up if the iris backend actually built.

## Scripts

Picked back up the numbered-script discipline from Chapters 5-10 this
session, a gap that had been flagged and deliberately deferred a few
sessions back. Everything from the Xorg build environment setup through
Mesa itself is now in scripts/11-xorg/, 25 numbered scripts as of this
point, committed to the repo in two batches.
