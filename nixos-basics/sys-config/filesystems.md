File Systems
============

* NixOS Manual section: [File Systems][nixos-man-fs].
* Background reading: [File Systems][arch-fs] on the Arch wiki.


File System Hierarchy Standard
------------------------------
NixOS deviates from the [FHS][wikipedia-fhs] in quite a few places. As
evil as it sounds, it's necessary to guarantee isolation and correct
dependencies as this developer [points out][nixos-fhs]. One unfortunate
consequence is that building a package from source with `make` is not
likely to work out of the box. (There's no `/usr/lib`, no `/usr/share`...)


Mounting
--------
### Basics
You use the `fileSystems` configuration option instead of `/etc/fstab`
or `systemd` units. For example, this Nix expression

    fileSystems."/tmp" = {
        fsType = "tmpfs";
        noCheck = true;
        options = [ "size=25%" "mode=1777" "nosuid" "nodev" ];
    };

mounts a `tmpfs` on `/tmp`, capping its size at 25% of available memory.
(Below is a quick explanation of how `tmpfs` works.) If you look under
the bonnet, you'll see that NixOS creates a `systemd` mount unit out of
each attribute in the `fileSystems` set.

### VirtualBox Shares
[Read this][vbox-shares] if you're running NixOS as a VirtualBox guest
and want to mount shared folders.

### Notes
###### fsck
I've added a `noCheck` in the expression above to skip the `fsck` check.
Not sure this is actually needed for a `tmpfs`...

###### tmp.mount
There's a `systemd` unit, `tmp.mount`, that mounts `tmpfs` on `/tmp` but
it uses the `strictatime` option which you probably do *not* want. (Read
the `mount` manual.) Also, it doesn't specify a size which is something
you may actually want.


tmpfs
-----
[tmpfs][arch-tmpfs] is a temp file system that resides in RAM and swap (if
you have a swap partition). The size of a `tmpfs` partition is dynamic: it
equals the size of the data currently written to it. While its size can't
be larger than the total amount of RAM+swap you have (d'oh!), you can cap
it so that it can never grow to fill up all the available memory.

For example, NixOS mounts a `tmpfs` partition on `/run` capping it at at
25% of RAM+swap (look at `boot.runSize`) but all that space is not used
anyway unless needed and will be available to the system.
Say your RAM+swap = 32GB, then 25% = 8GB. Out of those 8GB, `/run` won't
normally use more than a few megs anyway. So in actual fact, almost all
of those 8GB will be available to e.g. user programs.


Temp Files
----------
NixOS mounts a `tmpfs` on `/run` (see output of: `mount | grep tmpfs`) while
it manages other temp storage space through [systemd-tmpfiles][systemd-tmp].
The default rules cater for system stuff (e.g. `/var/tmp`) and X11 temp
files written to `/tmp` but don't clean up any other data written to `/tmp`.
So you have two options: mount a `tmpfs` partition on `/tmp` or clean it
up yourself. Here's a Nix expression that uses `systemd-tmpfiles` to set
up `/tmp` and delete files older than one day:

    systemd.tmpfiles.rules = [ "d /tmp 1777 root root 1d" ];

Or you could clean up at boot time:

    boot.cleanTmpDir = true;

A quick way of mounting `/tmp` on `tmpfs` is with

    boot.tmpOnTmpfs = true;

but you may want to use the `fileSystems` config option instead so you
can also specify a cap for the `tmpfs` partition size.


System Logs
-----------
NixOS uses `systemd` and its logging system, the "journal". The journal
size (=sum of all log files) defaults to 10% of the partition it's on.
Here's how to limit it to 500M:

    services.journald.extraConfig = "SystemMaxUse=500M";





[arch-fs]: https://wiki.archlinux.org/index.php/File_systems
    "File Systems"
[arch-tmpfs]: https://wiki.archlinux.org/index.php/Tmpfs
    "tmpfs"
[nixos-fhs]: http://sandervanderburg.blogspot.fr/2011/11/on-nix-nixos-and-filesystem-hierarchy.html
    "On Nix, NixOS and the Filesystem Hierarchy Standard (FHS)"
[nixos-man-fs]: https://nixos.org/nixos/manual/index.html#ch-file-systems
    "File Systems"
[systemd-tmp]: https://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html
    "systemd-tmpfiles"
[wikipedia-fhs]: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
    "Filesystem Hierarchy Standard"
[vbox-shares]: virtualbox.md#mounting-virtualbox-shares
    "Mounting VirtualBox Shares"
