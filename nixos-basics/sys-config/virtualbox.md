VirtualBox Guest
================
> Additional tweaks for running NixOS as a VirtualBox guest.


Creating a VM
-------------
The NixOS manual [recommends][nixos-vbox] you set at least the following
when creating a VM to host NixOS:

###### Name and operating system
* Type: Linux
* Version: Other Linux (64 bit)

###### Memory size
* Memory size: 768 MB or higher.

###### Hard drive
* Create a virtual hard drive of 8 GB or higher.

###### Settings ➲ System
* Processor
  + Enable PAE/NX
* Acceleration
  + Paravirtualization Interface: KVM

###### Settings ➲ Display
* Graphics Controller: VBoxVGA

### Notes
###### VT-x/AMD-V acceleration
The manual says to enable "VT-x/AMD-V" acceleration but I can't find that
setting under *Settings ➲ System ➲ Acceleration*. It's definitely enabled
on all my Macs, but I still can't see that setting in VirtualBox, even though
the VirtualBox summary pane correctly reports "Acceleration: VT-x/AMD-V".
Not sure what the story is here. More about enabling "VT-x/AMD-V" acceleration
[over here][enable-virt]; Macs specifics [here][enable-virt-macbook].

###### KVM
The NixOS manual doesn't mention it, but the VirtualBox manual does.
That's the right setting for a Linux guest.

###### VBoxVGA
The NixOS manual doesn't mention it, but if you set Graphics Controller to
anything else than "VBoxVGA", you'll end up with a black screen in your hands
when booting from the NixOS ISO or when booting NixOS itself after installation!


Additional NixOS Configuration
------------------------------
The NixOS installer should have added this to your `hardware-configuration.nix`:

    virtualisation.virtualbox.guest.enable = true;

It triggers the loading of VirtualBox kernel modules and guest additions.
If the setting is not there, add it to your config. You should also get
rid of `fsck` on boot with

    boot.initrd.checkJournalingFS = false;

cos, according to the manual, it'll always fail.


Mounting VirtualBox Shares
--------------------------
VirtualBox lets you access directories on the host from the guest OS through
the shared folders feature. Here are some notes about mounting VirtualBox
shared folders in a NixOS guest. These notes apply to VirtualBox on OS X,
but likely other Unix hosts (e.g. Linux) behave similarly; dunno about
Windows hosts though.

### Auto-mounting
You can have VirtualBox make the NixOS guest mount automagically a directory
`d` on the host if you check the auto-mount option in VirtualBox when adding
`d` as a shared folder. It'll then show as `/media/sf_d` in the NixOS guest.

Files in auto-mounted folders will be owned by `root` and have a group of
`vboxsf`. On creating a new file in NixOS, permissions will be set to `rwx`
(i.e. exec!) for both user and group; however, they will be `rw` in the host.

This is a good option for one-off quick file sharing between the host and
the guest, but it's a royal pain in the back if you want to work on those
files inside the guest and then keep the results in the host cos permissions
will be all messed up.

### Explicit Mount
Another option you have is that you do *not* check the auto-mount option
when adding a directory `d` to your VirtualBox shared folders. To be able
to mount shared folders, you'll have to mount with the `nofail` option and
disable the `rngd`, the random number generator daemon. If you don't do this,
the system won't boot! (Don't ask why; this is noted in the NixOS manual too.)
You can then easily mount it yourself from NixOS to tweak permissions, e.g.

    fileSystems."/vbox-shares/d" = {
        fsType = "vboxsf";
        device = "d";
        options = [ "nofail" "rw" "dmode=0777" "fmode=0666" ];
    };

    security.rngd.enable = false;

will give any user permissions to create files and directories in `d`
as well as read and write permissions on all existing files. If the
`/vbox-shares` directory doesn't exist, it'll be created for you.
(Change the name to whatever you like or even get rid of this extra dir
if you want `d` right under your root dir, i.e. `/d`.)

But you'll hit a snag with this approach: `root` owns all files and dirs,
even those other users create! That is, if you're logged in as `pwned`
with a primary group of `users` and run

    $ touch /vbox-shares/d/file

you'll see that `file`'s owner/group is `root`/`root`, not `pwned`/`users`!

To get around this, you can specify mount point ownership. For example,
let's say `pwned` has a uid of `1000` and his primary group `users` has
a gid of `100`. Then

    fileSystems."/vbox-shares/d" = {
        fsType = "vboxsf";
        device = "d";
        options = [ "nofail" "rw" "uid=1000" "gid=100" "umask=0022" ];
    };

mounts `d` with an ownership of `pwned`/`users` and ensures permissions
are set correctly in the guest and reflected too in the host.

### Notes
###### Figuring out uid, gid, and umask
Sure, you can use the `id` and `umask` commands. But you could use Nix
expressions as well, for example have a look at [this][vbox-shares].

###### VirtualBox Share Permissions Issue
[Look here][perms-issue] for more details about this issue.


Shrinking Virtual Disks
-----------------------
A VirtualBox dynamic hard disk grows in size as you fill it up in the
guest, but doesn't shrink back when you clean up junk in your guest.
But you can shrink it yourself to reclaim space on the host. If you
realise the HD space inside the VM as reported by e.g.

        $ df -h /dev/sda1 /dev/sda2

happens to be much less than the size of the VBox virtual HD file on
the host, then you may want to consider shrinking the virtual HD file.
Here's how to do. We first need to zero out all available free space
in the NixOS guest as VBox will only remove zeroed blocks. Run this
as root

        $ dd if=/dev/zero of=junk
        $ sync
        $ rm junk

Then shut down the VM, `cd` into the VM directory on the host, and run:

        VBoxManage modifyhd --compact your.hd.vdi

Note this will only shrink your current disk, not any previous snapshots.
But you can use this same procedure to compact previous snapshots if you
need to.

More info about virtual disks shrinking on the [Arch wiki][arch-vbox-compact]
as well as [here][shrink-vbox], [here][compact-vdi], and [here][mk-ext4-sparse].




[arch-vbox-compact]: https://wiki.archlinux.org/index.php/VirtualBox#Compact_virtual_disks
    "VirtualBox - Compact virtual disks"
[compact-vdi]: http://superuser.com/questions/529149/how-to-compact-virtualboxs-vdi-file-size
               "How to compact VirtualBox's VDI file size?"
[enable-virt]: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/
    "How to Enable Intel VT-x in Your Computer’s BIOS or UEFI Firmware"
[enable-virt-macbook]: http://stackoverflow.com/questions/13580491/how-to-enable-support-of-cpu-virtualization-on-macbook-pro
    "How to enable support of CPU virtualization on Macbook Pro?"
[mk-ext4-sparse]: http://unix.stackexchange.com/questions/11100/how-to-make-ext4-filesystem-sparse/11248#11248
                  "How to make ext4 filesystem sparse?"
[nixos-vbox]: https://nixos.org/nixos/manual/index.html#sec-instaling-virtualbox-guest
    "Installing in a Virtualbox guest"
[perms-issue]: http://askubuntu.com/questions/123025/what-is-the-correct-way-to-share-directories-in-mac-and-ubuntu-with-correct-perm
    "What is the correct way to share directories in Mac and Ubuntu with correct permissions?"
[shrink-vbox]: http://dantwining.co.uk/2011/07/18/how-to-shrink-a-dynamically-expanding-guest-virtualbox-image/
               "How to shrink a dynamically-expanding guest virtualbox image"
[vbox-shares]: ../../config/nixos/vbox-shares.nix
    "vbox-shares.nix"
