Apps Installation & Configuration
=================================

Below are the apps I've installed, in alphabetical order, and how I've
configured them. But first checkout the `mactop` branch of Trixie Dotses
as we'll be using `git` to manage as much config as we can.

    $ cd /Volumes/data/github
    $ git clone -b mactop https://github.com/c0c0n3/trixie-dotses.git

Note that you need to keep this repo around with the `mactop` branch
checked out as we'll be sym-linking config files and dirs.


Bamboo Tablet
-------------
Download the driver's installer package from [Wacom support][wacom-support].
You have to look for it in the "Drivers for Previous Generation Products"
section, where you'll find the download link for Bamboo CTH. The version I
downloaded is [pentablet_5.3.7-6.dmg][pentablet_5.3.7-6.dmg] (click to
download again).

###### NOTES
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


Git
---

    $ ln -s /Volumes/data/github/trixie-dotses/config/git/.gitconfig ~/
    $ ln -s /Volumes/data/github/trixie-dotses/config/git/.gitignore_global ~/


Fonts
-----

    $ brew cask install font-alegreya font-alegreya-sc
    $ brew cask install font-architects-daughter
    $ brew cask install font-cherry-cream-soda
    $ brew cask install font-kaushan-script

Now download and install *KG Miss Speechy IPA* yourself as I couldn't find
a cask for it. Then on to the next batch of installs:

    $ brew cask install font-sansita-one
    $ brew cask install font-source-code-pro
    $ brew cask install font-ubuntu
    
###### Notes
1. **Alegreya & AlegreyaSC**. Using both fonts for blog and doc sites.
The formulas above install all variants: black, black-italic, bold,
bold-italic, italic, regular.
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


Google Chrome
-------------

    $ brew cask install google-chrome


Inkscape
--------
Install the Inkscape 0.91 Quartz build using [this DMG][inkscape-dmg].
Then install [my configuration][inkscape-config].

###### Notes
1. Inkscape native (Quartz) builds. That's what you want. Much smoother
drawing experience than an X11 build running with the old X11 on OS X.
(Which you'll have to install, BTW; it doesn't ship with OS X anymore.)
2. Inkscape 0.92. Not yet available through Cask. If you feel adventurous
you can cruft together your own GTK3/Quartz installation, [read this]
[inkscape]!
3. Inkscape 0.91 Quartz DMG. I'm saving the only DMG that worked for me
in `extras` cos it's no longer available from `osxmenu`. It's the only
one pre-configured with a dark theme.


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
    $ brew linkapps emacs-plus

Hook up my config.

    $ ln -s /Volumes/data/github/trixie-dotses/config/.spacemacs.d ~/.spacemacs.d

Install spell checker.

    $ brew install aspell --with-lang-en

###### Notes
1. Spacemacs spell-checking layer. I load it in my config. It uses Flyspell
which needs an external spell checker. While there may be a way to use OS X
own spell checker, I think it's much easier to just install `aspell` also
because this is what Flyspell uses by default.
2. Dictionaries. The `aspell` formula comes with options to only install
the dictionaries you want instead of every freaking dictionary known to
man (the default!) which explains the `--with-lang-en` option above. This
keeps the whole `aspell` installation below 7MB.


Virtual Box
-----------
Install first

    $ brew cask install virtualbox virtualbox-extension-pack

Then set preferences as below:

* *General ➲ Default Machine Folder*: `/Volumes/data/VMs/`
* *Input ➲ Virtual Machine ➲ Host Key Combination*: right ⌘
* *Update ➲ Check for Updates*: off


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

### TAM Smart Card Plugin
TAM app to drive the smart card reader to use for buying monthly passes.
Not sure I'm going to need it...

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




[backup]: backup.md
    "Backups"
[inkscape]: inkscape.md
    "Inkscape"
[inkscape-config]: ../config/inkscape/README.md
    "Inkscape Set Up"
[inkscape-dmg]: ../extras/Inkscape-osxmenu-r12898-1-quartz-10.7-x86_64.dmg
    "Inkscape 0.91 Quartz DMG"
[keyboard]: ../../config/osx-keyboard/README.md
    "OS X Keyboard Layouts"
[pentablet_5.3.7-6.dmg]: http://cdn.wacom.com/u/productsupport/drivers/mac/consumer/pentablet_5.3.7-6.dmg
    "Wacom Driver Installer"
[spacemacs-install]: https://github.com/syl20bnr/spacemacs#install
    "Spacemacs Installation Docs"
[wacom-blog]: http://community.wacom.com/en/inspiration/blog/2014/october/using-wacom-drivers-with-mac-os-x-yosemite/
    "Using Wacom Drivers with Mac OS X Yosemite"
[wacom-support]: http://www.wacom.com/en-us/support/product-support/drivers
    "Wacom Product Support"
