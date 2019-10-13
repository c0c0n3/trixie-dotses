Apps Installation & Configuration
=================================

Below are the apps I've installed, in alphabetical order, and how I've
configured them. But first checkout the `mactop` branch of Trixie Dotses
as we'll be using `git` to manage as much config as we can.

    $ cd /Volumes/data/github
    $ git clone https://github.com/c0c0n3/trixie-dotses.git

Note that you need to keep this repo around as we'll be sym-linking config
files and dirs.


Astropad
--------

    $ brew cask install astropad

###### Notes
1. **Sidecar**. Catalina ships with iPad & pencil integration which kinda
make Astropad redundant. Sadly, Sidecar requires MacBook Pro 2016 or newer
so my oupa mid 2012 can't run it.


Git
---

    $ ln -s /Volumes/data/github/trixie-dotses/config/git/.gitconfig ~/
    $ ln -s /Volumes/data/github/trixie-dotses/config/git/.gitignore_global ~/


Fonts
-----

    $ brew cask install font-alegreya
    $ brew cask install font-architects-daughter
    $ brew cask install font-cherry-cream-soda
    $ brew cask install font-kaushan-script
    $ brew cask install font-source-code-pro
    $ brew cask install font-ubuntu
    
Now download and install *KG Miss Speechy IPA* and *Sansita One* yourself
as I couldn't find a cask for it. Same for the [icon fonts][all-the-icons-fonts]
used by the [all-the-icons.el][all-the-icons] Emacs package.

###### Notes
1. **Alegreya & AlegreyaSC**. Using both fonts for blog and doc sites.
The `font-alegreya` formula above contains both and installs all variants:
black, black-italic, bold, bold-italic, italic, regular.
2. **Architects Daughter**. I used it for lots of maths (hand-drawn)
diagrams but have now switched to *KG Miss Speechy IPA*.
3. **Cherry Cream Soda**. Been using it for presentations.
4. **Kaushan Script**. Blog and doc sites.
5. **KG Miss Speechy IPA**. Maths diagrams. It's the closest *Architects
Daughter*-like font I could find. (I really like *Architects Daughter* but
it doesn't have Greek letters!)
6. **Sansita One**. Maths diagrams.
7. **Source Code Pro** is for my Spacemacs theme.
8. **Ubuntu**. Actually the only font in the family I've ever used is
*Ubuntu Mono* for presentations, but couldn't find a cask for just this
font, so am installing the whole family.
9. [all-the-icons.el][all-the-icons]'s fonts add some eye-candy to my
Spacemacs theme.

Google Chrome
-------------

    $ brew cask install google-chrome


Inkscape
--------
Install the Inkscape 0.91 native build using the DMG stashed away in the
[draft release][inkscape-dmg]. Then install [my configuration][inkscape-config].

###### Notes
1. Inkscape native builds. That's what you want. Much smoother drawing
experience than an X11 build running with X11 on macOS. (BTW you'll have
to install Quartz to run an X11 build of Inkscape since the old X11 doesn't
ship with macOS anymore.)
2. Inkscape 0.92. Available through Cask but it's the X11 build. In fact,
the formula just installs the official DMG for macOS from Inkscape which
is still based on X11. If you feel adventurous you can cruft together your
own GTK3 native installation, [read this][inkscape]!
3. Inkscape 0.91 DMG. Saved to a [draft release][inkscape-dmg] cos it's
no longer available from `osxmenu`. It's the only native build with macOS
integration and dark theme that worked for me.
4. Inkscape 1.0. Might be out before the end of 2019! Read my comments
about it on [this GitHub issue][inkscape-dmg].


Rclone
------

    $ brew install rclone

###### Notes
The only thing I'm using Rclone for is to [make backups][backup] to my
Google drives.


Skype
-----

    $ brew cask install skype


Spacemacs
---------
Following the official [installation steps][spacemacs-install] for OS X. 
First clone the Spacemacs repo

    $ git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

Then install Emacs using the `emacs-plus` formula cos it builds Emacs with
some options that make it more Mac-friendly as well as the Spacemacs icon.

    $ brew tap d12frosted/emacs-plus
    $ brew install emacs-plus
    $ ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications

Hook up my config.

    $ ln -s /Volumes/data/github/trixie-dotses/config/.spacemacs.d ~/.spacemacs.d

Install spell checker.

    $ brew install aspell

###### Notes
1. Spacemacs spell-checking layer. I load it in my config. It uses Flyspell
which needs an external spell checker. While there may be a way to use OS X
own spell checker, I think it's much easier to just install `aspell` also
because this is what Flyspell uses by default.
2. Dictionaries. The `aspell` formula used to come with options to only
install the dictionaries you want instead of every freaking dictionary
known to man, so I used to install with `brew install aspell --with-lang-en`
which kept whole `aspell` installation below 7MB. Sadly, the maintainers
decided to [ditch support for specifying dictionaries][aspell.remove-opts]
and now the formula pulls down one gazillion dictionaries, winding up with
a fat install of over 300MB. Ouch!


Virtual Box
-----------
Install first

    $ brew cask install virtualbox virtualbox-extension-pack

The installer will fail and a dialog will pop up nagging you about security,
just click through to get to *System Preferences ➲ Security & Privacy ➲
General* where there should be a note saying Oracle software was blocked
from loading and an *Allow* button. Hit the button to allow VBox to load
kernel extensions. Now run the command above again to get the job done:

    $ brew cask install virtualbox virtualbox-extension-pack

Then set preferences as below:

* *General ➲ Default Machine Folder*: `/Volumes/data/VMs/`
* *Input ➲ Virtual Machine ➲ Host Key Combination*: right ⌘
* *Update ➲ Check for Updates*: off

###### Note
Since Mojave, the first installation attempt [fails][vbox-kext] due to
KEXT security.


On Hold
-------
Here's a list of apps that I had before upgrading to Sierra but I'm not
reinstalling for the time being. May change my mind though.

### Apple Built-in Apps
Back in 2010 when I bought my other mactop, OS X shipped with Garage Band,
iMovie, and iPhoto. They weren't in Sierra, but I can still download them
form the App Store if I wanted to. I can count on the fingers of one hand
the number of times I've used these apps, so am not installing any of them
for now.

### Bamboo Tablet
Not using it anymore, but if you need it again, follow the instructions below.

Download the driver's installer package from [Wacom support][wacom-support].
You have to look for it in the "Drivers for Previous Generation Products"
section, where you'll find the download link for Bamboo CTH. The version I
downloaded is [pentablet_5.3.7-6.dmg][pentablet_5.3.7-6.dmg] (click to
download again).

###### Notes
1. **How to uninstall?** The driver's installer package installs a Wacom Utility
app; open it up and click on the Remove button under Tablet Software. It'll
do a clean uninstall of the driver and then remove itself too.
2. **Why not use Homebrew?** Cos the formula doesn't clean up all the installed
files. (The Wacom Utility is still in the Applications folder after a `zap`
and you have to uninstall it yourself.)
3. **A bit of history**. I initially installed driver and apps from my DVD.
Never really used the apps and the driver stopped working after upgrading
from OS X 10.9 (Mavericks) to OS X 10.10 (Yosemite): OS X moved it into
`/Incompatible Software` during the upgrade. I then installed a new driver
(`pentablet_5.3.5-4.dmg`) that Wacom [released][wacom-blog] for Yosemite.

### SourceTree
Homebrew forced me to install the XCode CLI tools which include `git` so
it's pointless to install SourceTree too cos when I need a UI I actually
use GitHub.

### Unarchiver
Almost never used. Can download again from App Store.

### Ukelele
I only used it to create a custom [keyboard layout][keyboard] that I'm not
using at the moment, so it's kinda pointless to reinstall it.

### VLC
Only been watching videos online lately. Not missing this guy just yet.

### Zoom
Used it for conf calls only cos the old box I had at work wasn't happy
with it so I had to put it on my personal laptop.




[all-the-icons]: https://github.com/domtronn/all-the-icons.el
    "all-the-icons.el on GitHub"
[all-the-icons-fonts]: https://github.com/domtronn/all-the-icons.el/tree/master/fonts
    "all-the-icons.el fonts directory on GitHub"
[aspell.remove-opts]: https://github.com/Homebrew/homebrew-core/pull/36225
    "Aspell: remove options"
[backup]: backup.md
    "Backups"
[inkscape]: inkscape.md
    "Inkscape"
[inkscape-config]: ../../config/inkscape/README.md
    "Inkscape Set Up"
[inkscape-dmg]: https://github.com/c0c0n3/trixie-dotses/issues/7
    "Inkscape-osxmenu-r12898-1-quartz-10.7-x86_64.dmg"
[keyboard]: ../../config/osx-keyboard/README.md
    "OS X Keyboard Layouts"
[pentablet_5.3.7-6.dmg]: http://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg
    "Wacom Driver Installer"
[spacemacs-install]: https://github.com/syl20bnr/spacemacs#install
    "Spacemacs Installation Docs"
[vbox-kext]: https://apple.stackexchange.com/questions/301303
    "VirtualBox 5.1.28 fails to install on MacOS 10.13 due to KEXT security"
[wacom-blog]: http://community.wacom.com/en/inspiration/blog/2014/october/using-wacom-drivers-with-mac-os-x-yosemite/
    "Using Wacom Drivers with Mac OS X Yosemite"
[wacom-support]: http://www.wacom.com/en-us/support/product-support/drivers
    "Wacom Product Support"
