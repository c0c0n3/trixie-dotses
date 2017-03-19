NixOS Basics
============
> Getting to know NixOS.

NixOS is a Linux distro grounded on a declarative system configuration
model that, unlike most other distros, guarantees reliable, atomic system
upgrades as well as the ability to rollback to a previous system state.
Each system state is the result of NixOS realising (atomically) a system
configuration you write in a purely functional configuration language.
You can take any configuration you've written to reproduce the corresponding
system state on another machine.


About This Doc
--------------
After combing the interwebs, I decided to collect in one place what I've
found useful as a *starting point* to be able to run NixOS and keep the
system in good shape. Much of the stuff I've collected here comes from
the Nix and NixOS manuals, the NixOS wiki, and the Arch wiki. I've found
that NixOS docs are overall good but lack depth, so I've used the Arch
wiki alot to fill the gaps. In particular, the [General Recommendations]
[arch-recommends] page on the Arch wiki is a terrific source of knowledge.


Contents
--------
1. [About NixOS][about-nixos]. Straight from NixOS home, a must-read, clear,
short and sweet explanation of what NixOS is and what it can do.
2. [NixOS Core Installation][install]. How to get a bare bones NixOS system
up and running from scratch.
3. [Configuration 101][config-101]. Intro to the NixOS configuration model
with pointers to essential sections in the manual.
4. [Package Management][package-mgmt]. How to (un-)install & upgrade software
in NixOS.
5. [System Configuration][sys-config]. Assembling the system to your liking.
6. [Runtime Management][runtime-mgmt]. Managing a running system.
7. [System Maintenance][sys-maintenance]. Making sure your box keeps running
smoothly.




[about-nixos]: https://nixos.org/nixos/about.html
    "About NixOS"
[arch-recommends]: https://wiki.archlinux.org/index.php/general_recommendations
    "General Recommendations"
[config-101]: config-101.md
    "Configuration 101"
[install]: core-install/README.md
    "NixOS Core Installation"
[package-mgmt]: package-mgmt.md
    "Package Management"
[runtime-mgmt]: runtime-mgmt.md
    "Runtime Management"
[sys-config]: sys-config/README.md
    "System Configuration"
[sys-maintenance]: sys-maintenance.md
    "System Maintenance"


