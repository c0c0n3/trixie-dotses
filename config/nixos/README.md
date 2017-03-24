Notes to Self
=============
> TODO turn into a decent readme you'll be able to understand a year from now!


Install
-------
After installing NixOS:

    $ cd /etc/nixos
    $ rm configuration.nix
    $ ln -s /path/to/trixie-dotses ./
    $ ln -s trixie-dotses/config/nixos/[machine name].nix configuration.nix
    $ nixos-rebuild switch

    
Hacking
-------
### boxes
Top-level Nix expressions to build a system. One directory for each box I
use, named after that box's host name.

### modules/generic
General-purpose modules you can possibly use somewhere else.
Options defined here should always be in the `ext` (for extensions) name
space.

### modules/dotses
Modules and utils to configure my machines using this repo's dot files.
Options defined here should always be in the `ext` (for extensions) name
space.

### pkgs
Nix expressions to build packages that I couldn't find in the official
packages tree. They're implemented so that you can easily use them outside
of a package tree, with a simple import, e.g.

    fonts.fonts = [ (import ./pkgs/fonts/alegreya-sans.nix) ];

### Non-free Packages
By default Nix won't install packages that have a non-free software license.
This is a **good** thing IMO, cos it stops you from inadvertently installing
software that might get you into legal issues---think of a server VM deployed
in the cloud. So **keep non-free packages out of your modules**. If you need
a non-free package, add it to the top-level Nix expression to build the system
so that it's more visible. For the same reason, if you need non-free packages,
there should be only one

    nixpkgs.config.allowUnfree = true;

Nix expression in the top-level machine file so that you can easily turn it
off (=`false`) and see what packages are not free. See also the [discussion
about non-free packages][nix-unfree] in the Nix-dev mailing list.




[nix-unfree]: http://lists.science.uu.nl/pipermail/nix-dev/2014-April/012917.html
    "Unfree packages in Nixpkgs"
