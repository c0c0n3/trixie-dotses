Configuration 101
=================
> Or what the hell is going on in `/etc`?! 

You build and configure a NixOS system using a config spec that declares
how to assemble and bring the whole operating system into the state you
want it to be in. System state here typically means kernel, drivers, apps,
config files, and the like but usually not "mutable state"---e.g. data in
`/var`. A config spec is a program, written in a functional programming
language, that NixOS executes to realise the system state you've declared.
Quite a departure from old school Unix where you'd use plain old text files
in `/etc` and command line tools!


Basic Operation
---------------
You write a config spec out of [Nix expressions][nix-man-expr]. That is,
you basically write a config spec in a functional language where you can
abstract, modularise, and so on. You have the power of functions and
modules to keep configuration complexity at bay---and keep your sanity.
NixOS comes with modules for most configuration tasks, so typically all
you actually need to do is tweak the existing Nix expressions to your
liking. Cool bananas! The main module (think program entry point) for
system-wide configuration is

    /etc/nixos/configuration.nix

Every time you change your sys config you have to

    $ sudo nixos-rebuild switch

to activate it. This command takes care of service reconfiguration too
and makes your config the default one you'll boot in. (But keeps previous
configs in your boot menu.) If you mess up, it's easy to roll back to a
previous configuration you know worked, e.g.

    $ nixos-rebuild switch --rollback

takes you right back where you were before running `nixos-rebuild switch`.
(You can go further back in time to an older config state just as easily;
also, you can select previous configs from your boot menu.)


Getting Your Feet Wet
---------------------
While you can manage system configuration using command-line utils just
like in any other distro, NixOS comes with Nix modules for many config
tasks and lets you easily put together your own. This means you can happily
hack your way to a NixOS configuration that specifies how to get your system
in its current state, similar to what you'd do with Ansible, Puppet, or Chef.
For example, instead of creating a user account with `useradd`, you can
declare it in your system config (example lifted from the manual):

    users.users.alice = {
        isNormalUser = true;
        home = "/home/alice";
        description = "Alice Foobar";
        extraGroups = [ "wheel" "networkmanager" ];
        openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
    };

If something is not available through existing NixOS modules, chances are
there's hooks for shell commands. In fact, here's another example lifted
from the manual that shows you how to run a command to configure a static
IPv6 address:

    networking.localCommands =
        ''
            ip -6 addr add 2001:610:685:1::1/64 dev eth0
        '';

And ya, you're free to take it a step further and write your own modules
and packages using [Nix expressions][nix-man-expr].


Going Deeper
------------
Manual sections to read:

* [Configuration Syntax][nixos-man-cfg-syntax]. (Comes with a handy
[cheat sheet][nixos-man-cfg-syntax-sum] too.)
* [Changing the Configuration][nixos-man-chg-cfg].
* [Rolling Back Configuration Changes][nixos-man-rollback].




[nix-man-expr]: http://nixos.org/nix/manual/#chap-writing-nix-expressions
    "Nix Manual - Writing Nix Expressions"
[nixos-man-cfg-syntax]: https://nixos.org/nixos/manual/index.html#sec-configuration-syntax
    "NixOS Manual - Configuration Syntax"
[nixos-man-cfg-syntax-sum]: https://nixos.org/nixos/manual/index.html#sec-nix-syntax-summary
    "NixOS Manual - Configuration Syntax Summary"
[nixos-man-chg-cfg]: https://nixos.org/nixos/manual/index.html#sec-changing-config
    "NixOS Manual - Changing the Configuration"
[nixos-man-rollback]: https://nixos.org/nixos/manual/index.html#sec-rollback
    "NixOS Manual - Rolling Back Configuration Changes"
