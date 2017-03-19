NixOS Core
==========
> Guide to a spartan foundation.

A minimalist approach to installing and running NixOS that tries to keep
things as simple as possible. You can use this as a starting point to
develop something more sophisticated.


The Plan
--------
The steps below detail how to install a minimal NixOS base from which you
can build on. The idea is to have simple, minimal instructions that you
can tweak or use as a starting point to build something more complicated.
In a nutshell, this is what we're going to do:

* Boot from UEFI firmware. (We assume your box has [UEFI][uefi].)
* Use an entire hard drive to host two GPT partitions: one to boot the
system and the other to store both NixOS and all your data.
* Install the NixOS CLI core with no additional apps or UI.

Additionally, we detail optional steps to encrypt the NixOS and data
partition, just in case you need encryption. The installer needs to pull
stuff down from the NixOS repo so you need a working network connection.
(The installer works out of the box with a wired connection, but you can
tweak it to go wireless if you need to.)


Installing
----------
So here are the steps for installing from scratch.

1. [Prep Steps][prep-steps]. What to do before installing.
2. [OS Installation][os-install]. Minimal NixOS CLI installation.

Once you're through with the installation, you'll have a fully functional
NixOS core with a bare CLI and nothing else on it. So you may want to put
in place some minimal configuration, e.g. network, locale, users, etc.




[uefi]: https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface
    "Unified Extensible Firmware Interface"
[nixos-manual]: https://nixos.org/nixos/manual/
    "NixOS Manual"
[os-install]: os-install.md
    "OS Installation"
[prep-steps]: prep-steps.md
    "Prep Steps"
