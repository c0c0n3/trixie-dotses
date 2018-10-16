Graphical User Interface
========================

* NixOS manual section: [X Window System][nixos-man-x].
* Background reading: [GUI][arch-gui] on the Arch wiki.


No-frills Desktop
-----------------
These Nix expressions make X start at boot and XMonad the window manager.

    services.xserver.enable = true;
    services.xserver.windowManager.xmonad.enable = true;

The first expression implicitly brings in SLiM as a display manager.
You'll probably want to also enable proprietary drivers if you have
an NVIDIA or AMD card. And the touch pad if you have a laptop.

### Notes
###### Display Managers
I've bumped into [this discussion][nixos-dev-dm] where devs argue moving
away from SLiM as default DM. Definitely an interesting discussion that
makes me think about DM choices...


Automatic Login
---------------
In some cases, it's nice to boot your box and be logged in automagically.
Think of a dev VM for example where having to log in is just a pain in
the neck. In Arch Linux you can easily set up [automatic login][arch-auto-login]
to a virtual console. Once you can do that, it's sort of straightforward
to take it a step further and just boot right into a GUI. For example,
you could start X from your `.bash_profile` and use an `.xinitrc` to
start a window manager without going through a display manager.

Even though you can configure NixOS to do an automatic login, you'll still
need a display manager cos NixOS doesn't support starting a window manager
without a display manager. But you can hide the display manager and make it
look like you've booted straight into your window manager environment
without a login. Here's how to do it:


    services.xserver = {
      enable = true;

      # enable a window manager, e.g. i3.
      windowManager.i3.enable = true;

      # log usr in without a password, hiding the display manager login
      # prompt.
      displayManager.auto = {
          enable = true;
          user = config.users.users.usr.name;
      };

      # but you'll need these two lines to make it work!
      windowManager.default = "i3";  # same as the window manager you chose.
      desktopManager.xterm.enable = false;
    };

Note the last two lines. You'll need both for auto login to work properly.
Without either of them, you'll end up with an xterm on screen and no window
manager.

### Notes
###### Automatic Login Issues
Peeps have [reported][nix-dev-auto-login] in the dev mailing lists that

    services.xserver.displayManager.auto

alone doesn't work, like I said you get an xterm and no WM. They suggest
using

    services.xserver.displayManager.sessionCommands

to start a WM, which works, but doesn't seem the best option though.
In fact if I read [this code][nixos-code] right and this is actually
where `sessionCommands` is called, then starting a WM there prevents
the rest of the script from running?


Fonts
-----
The NixOS manual doesn't have a specific chapter about fonts, but there's
[wiki page][nixos-fonts] you can look at. What's happening under the hood
is that by default:

    fonts.fontconfig.enable = true;
    
which configures `fontconfig` nicely, mostly using `fontconfig` ultimate
settings---formerly known as Infinality. Also, the usual `fc-*` CLI utils
should be in your path. Some apps may need to have

    fonts.enableFontDir = true;
    fonts.enableGhostscriptFonts = true;

(These two options are disabled by default.)

### Adding or Removing Fonts
Install fonts by adding the corresponding packages to the `fonts.fonts`
list, e.g.

    fonts.fonts = with pkgs; [ font-awesome-ttf ubuntu_font_family ];

How to remove a font? Um, well, let's see...remove it from the list? D'oh!

### Default Fonts
When you enable X, NixOS automatically installs a handful of common fonts
like Deja Vu and Liberation. In fact the X11 module (`X11/xserver.nix`)
sets

    fonts.enableDefaultFonts = true;

which triggers the installation of these fonts. To specify system-wide
default fonts, use

    fonts.fontconfig.defaultFonts.monospace
    fonts.fontconfig.defaultFonts.sansSerif
    fonts.fontconfig.defaultFonts.serif

### Hacking
What to do if there's no package for the font you want? Well, it isn't
hard to actually put together your own package---just use one of the
packages in `pkgs/data/fonts/` as a baseline.

But if you're in the mood for cheap hacks, here's one for you. To install
a font file `DaFont.ttf`, add a sub-directory `dafont` to your NixOS config
directory (e.g. `/etc/nixos`) and put `DaFont.ttf` in it. Then create a
file `dafont/default.nix` with these contents:

    with import <nixpkgs> {};

    stdenv.mkDerivation rec {
        name = "dafont";
        src = ../dafont;
        installPhase =
        ''
            mkdir -p $out/share/fonts/truetype
            cp DaFont.ttf $out/share/fonts/truetype/
        '';
    }

Now you can install `DaFont` with e.g.

    fonts.fonts = [ (import ./dafont) ];

Quick & dirty! This works for TTF font files but you'll have to come up
with your own hack for OTF fonts.




[arch-auto-login]: https://wiki.archlinux.org/index.php/Getty#Automatic_login_to_virtual_console
    "getty - Automatic Login to Virtual Console"
[arch-gui]: https://wiki.archlinux.org/index.php/General_recommendations#Graphical_user_interface
    "Graphical User Interface"
[nixos-code]: https://github.com/NixOS/nixpkgs/blob/release-16.09/nixos/modules/services/x11/display-managers/default.nix#L94
    "NixOS code"
[nix-dev-auto-login]: http://lists.science.uu.nl/pipermail/nix-dev/2015-June/017493.html
    "[Nix-dev] services.xserver.displayManager.auto does not work"
[nixos-dev-dm]: https://github.com/NixOS/nixpkgs/issues/12516
    "Proposal: Change the default display manager"
[nixos-fonts]: https://nixos.org/wiki/Fonts
    "Fonts"
[nixos-man-x]: https://nixos.org/nixos/manual/index.html#sec-x11
    "X Window System"
