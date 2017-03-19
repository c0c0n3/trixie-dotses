System Maintenance
==================
> Making sure your box keeps running smoothly.

Every now and then you should check up on your machine to see if she's
still happy.


Rescue Mode
-----------
If things get real bad, you can get into a rescue-mode root shell with
most of the system services stopped:

    $ sudo systemctl rescue

When you're done fixing stuff, quit the shell to get back to your normal
environment.


Storage
-------
Basic disk space checks:

    $ df -h                 # how much space is left?
    $ sudo du -hs /*        # high-level view of dir sizes
    $ du -i                 # do we still have enough i-nodes?

Note that NixOS checks file system consistency (`fsck`) at boot. (Look
at the docs for `boot.initrd.checkJournalingFS`.)

Additionally, if you're running NixOS as a VirtualBox guest, from time
to time, you may want to [shrink virtual disks][vbox-shrink] to reclaim
space on the host.


Log Analysis
------------
There's loads you can learn about your system's health from system and
service log files. For example whatever

    $ journalctl -b -x -p 2

spits out needs your undivided attention. (`-p` lets you specify the
[priority level][arch-systemd-logs].) These are possibly serious issues
you have to fix! If, on top of that, you want to bring in other errors
as well

    $ journalctl -b -x -p 3

but don't loose sleep on errors at level 3. Also take into account some
of them may be firmware issues that a firmware upgrade could fix. I've
seen errors logged at the wrong level, so if you're paranoid you might
just as well run

    $ journalctl -b | egrep -i 'fail|error'

As good measure, you should also look into any `systemd` units that failed

    $ systemctl --failed

And as you're at it, it's a good thing to know if X is acting up

    $ journalctl -b -u display-manager | egrep 'EE|WW'

### Notes
###### X Logs
NixOS makes X log to the journal, but this is tied to the display manager
you use. It works for SLiM, but still doesn't for LightDM as far as I can
tell. In fact, there's an [issue still open][nixos-x-logs] on GitHub for
this. Anyhoo, if you can't find the X logs in the journal, look into
`/var/log`, e.g.

    $ grep EE /var/log/X.0.log
    $ grep WW /var/log/X.0.log

(The 0 you see above stands for the display number.)


NixOS Store
-----------
From time to time you should remove unreferenced packages as well as old
system configurations (generations) you're not using anymore. To spring
clean the Nix store:

    $ sudo nix-collect-garbage -d
    
Be careful though, this deletes both unreferenced packages and all config
generations (across profiles) except for the current generation, so you
can't rollback to a previous state after running this command. Sure enough,
you can fine-tune what to delete---read the NixOS manual! But here's one
thing I couldn't find in the manual. If you delete previous generations
from the NixOS store, for some reason NixOS still keeps the last 11 boot
entries before the current in the `systemd-boot`'s boot menu. In fact,
there's a file for each of those generations in `/boot/loader/entries`
and the `nix-*` commands don't seem to clean them up. Long story short:
clean up yourself, e.g.

    $ cd /boot/loader/entries
    $ sudo rm nixos-generation-{1,2,3}.config  # assuming 4 is the current

This other command below is also useful to make more room in your drive
since it optimises file sharing in the NixOS store.

    $ sudo nix-store --optimise

Another good thing to do is check for broken dependencies (and fix them!)
that you could end up having if your system crashes badly in the middle
of running a Nix operation:

    $ nix-store --verify --check-contents

For more about NixOS store and package maintenance:

* [Cleaning the Nix Store][nixos-man-gc]. NixOS manual chapter on the Nix
store.
* [Nix Garbage Collection][nix-man-gc]. Nix manual chapter on garbage
collection; complements the chapter on the Nix store.
* [NixOS Store Corruption][nixos-man-store-corruption]. Explains what to
do if, after a system crash, the store becomes corrupted.
* [NixOS Store Network Problems][nixos-man-store-net]. What to do if Nix
operations take a long time cos of HTTP timeouts.




[arch-systemd-logs]: https://wiki.archlinux.org/index.php/Systemd#Priority_level
    "systemd - Log Priority Level"
[nix-man-gc]: http://nixos.org/nix/manual/#sec-garbage-collection
    "Nix Manual - Garbage Collection"
[nixos-man-gc]: https://nixos.org/nixos/manual/index.html#sec-nix-gc
    "NixOS Manual - Cleaning the Nix Store"
[nixos-man-store-corruption]: http://nixos.org/nixos/manual/index.html#sec-nix-store-corruption
    "NixOS Store Corruption"
[nixos-man-store-net]: http://nixos.org/nixos/manual/index.html#sec-nix-network-issues
    "Network Problems"
[nixos-x-logs]: https://github.com/NixOS/nixpkgs/issues/19236
    "Verify that X server logs are written to the journal"
[vbox-shrink]: sys-config/virtualbox.md#shrinking-virtual-disks
    "Shrinking Virtual Disks"
