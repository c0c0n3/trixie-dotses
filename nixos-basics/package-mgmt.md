Package Management
==================
> How to (un-)install & upgrade software in NixOS.

Like any other distro, NixOS has its own package manager, called Nix.
Below is a lunar-orbit view of package management in NixOS.


Nix
---
Nix is NixOS's workhorse, so it's a good idea to do some background
reading about it. The essentials:

* [Introduction][nix-man-intro]. Getting the what and the how.
* [Basic Package Management][nix-man-pkg-mgmt]. Using `nix-env` to 
(un-)install, upgrade, and query packages.
* [Profiles][nix-man-profiles]. Or what's going on under the hood.
Think of a profile as whole system environment (config + packages) you
can switch to.
* [Channels][nix-man-channels]. Where packages come from.

If you still have some time to spare, why not learning about

* [Nix Expressions][nix-man-expr]. A purely functional language for
building and configuring packages. Wow!

Knowing the language comes handy when dealing with NixOS configuration.
Also, you'll need to know it if you want to put together your own packages.
(Not as difficult as it sounds!)


NixOS Channels
--------------
Packages come from repos called "channels". If you subscribe to a channel,
you can install packages from that channel. The NixOS installer subscribes
you to the "nixos" (stable) channel of the NixOS release you've installed,
as you can see from

    $ nix-channel --list | grep nixos

Use `nix-env` to see what packages are available to install, e.g.

    $ nix-env -qaP '.*emacs.*' --description


(Un-)Installing and Upgrading
-----------------------------
System-wide packages should normally go in the NixOS system config, e.g.

    environment.systemPackages = [ pkgs.emacs ];

As usual, `nixos-rebuild switch` implements your config, taking care of
the packages you've declared:

* *Installation*. Any package you've added will be installed.
* *Removal*. Any package you've removed will be uninstalled.

To *upgrade* your existing packages and NixOS to the latest available in
the channels you've subscribed to:

    $ nixos-rebuild switch --upgrade

Keeping packages in your system configuration makes it possible to easily
reinstall the system from scratch with a single `nixos-rebuild switch`.


User Packages
-------------
For user-specific packages, each user can manage their own set using
`nix-env`. For example,

    $ nix-env -iA nixos.emacs

installs Emacs only in the current user's environment. Installed packages
get recorded in `~/.nixpkgs/config.nix`, so you could alternatively use a
configuration-based approach where you edit this file to add and/or remove
packages, then

    $ nix-env -i all

to realise your configuration. As a user, you can have as many environments
(Nix profiles) as you like and use `nix-env` to switch to any of them.

There's a [NixOS wiki page][nixos-wiki-pkg-updates] you can read to find
out more about updating packages and using the configuration-based approach
(a.k.a. package collections) outlined above.


More About Package Management
-----------------------------
So you've taken the whirlwind tour. Now you may want to read the NixOS
manual to learn how to fine-tune what gets installed when and how:

* [Upgrading NixOS][nixos-man-upgrading]. Keeping your system up-to-date
using NixOS channels.
* [Package Management][nixos-man-pkg-mgmt]. (Un-)Installing, upgrading,
and customising packages.
* [Cheat sheet][nixos-wiki-pkg-mgmt]. Handy comparison with Debian-like
package management.

Also don't forget to do some background reading about Nix: [basic package
management][nix-man-pkg-mgmt], [profiles][nix-man-profiles], and 
[channels][nix-man-channels].




[nix-man-channels]: http://nixos.org/nix/manual/#sec-channels
    "Nix Manual - Channels"
[nix-man-expr]: http://nixos.org/nix/manual/#chap-writing-nix-expressions
    "Nix Manual - Writing Nix Expressions"
[nix-man-intro]: http://nixos.org/nix/manual/#chap-introduction
    "Nix Manual - Introduction"
[nix-man-pkg-mgmt]: http://nixos.org/nix/manual/#ch-basic-package-mgmt
    "Nix Manual - Basic Package Management"
[nix-man-profiles]: http://nixos.org/nix/manual/#sec-profiles
    "Nix Manual - Profiles"
[nixos-man-pkg-mgmt]: https://nixos.org/nixos/manual/index.html#sec-package-management
    "Package Management"
[nixos-man-upgrading]: https://nixos.org/nixos/manual/index.html#sec-upgrading
    "Upgrading NixOS"
[nixos-wiki-pkg-mgmt]: https://nixos.org/wiki/Cheatsheet
    "Cheat sheet"
[nixos-wiki-pkg-updates]: https://nixos.org/wiki/Howto_keep_multiple_packages_up_to_date_at_once
    "How to keep multiple packages up to date at once"
