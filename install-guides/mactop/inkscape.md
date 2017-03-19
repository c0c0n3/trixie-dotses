Inkscape
========
> Bleeding edge native set up.

If you want to play around with the latest Inkscape 0.92, read on, but
beware this is a bit of a disaster area at the moment.

The Good
--------
Starting from version 0.92, Inkscape is available as a native (Quartz)
build. This means you don't need to install X11 anymore, it just runs
like any other OS X app. So I can ditch the experimental 0.91 Quartz
build I've used up until now, that is, for the record:

    Inkscape-osxmenu-r12898-1-quartz-10.7-x86_64.dmg


The Bad
-------
Cask only has a DMG for 0.91 for X11 (i.e. non-native) and there seems
to be no 0.92 DMG in sight. The [Homebrew GUI Tap][homebrew-gui] used to
have a formula you can use to get the 0.92 Quartz build, but what you get
is just the GTK app, not the Mac-friendly version. That is, there's no DMG
and Inkscape gets installed as a CLI program in `/usr/local/bin` rather
than in a nicely packaged OS X app bundle in `/Applications`. So you get
no OS X integration (Launchpad/Finder/Docker). Also, the formula pulls
down about 800MB of deps before installing the Inkscape binary (of about
100MB). But Inkscape still works as expected when started from the command
line, warts and all.


The Ugly
--------
Until I find a better option, I'll be using the hodgepodge of files below
to install Inkscape 0.92 (Quartz) with GTK 3 and dark theme as well as
basic OS X integration. Bear in mind that the GTK 3 build is still buggy
and you should rather use the official GTK 2 build. Except GTK 2 is ugly
as hell!


Installation
------------
First we need the Homebrew formula. Not as straightforward as usual cos
it's been deleted. (Actually, the whole [Homebrew GUI Tap][homebrew-gui]
has been deprecated!) Anyhoo,

    $ brew tap homebrew/gui

Then put the Inkscape formula back into the tap. You can find it in [pull
request 47][homebrew-gui-pr-47]. 

    $ cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-gui
    $ git checkout 53441546ded7da09a5b89a405ad0766deb455989
    $ cp inkscape.rb ~/Downloads/
    $ git checkout master
    $ cp ~/Downloads/inkscape.rb ./
    
Now install Inkscape 0.92 (Quartz) with GTK 3 and Poppler support:

    $ brew install inkscape --with-gtk3 --with-poppler
    $ rm inkscape.rb

Before you can use it, you need to install icons and possibly a decent
theme. I'm using Numix, read [how to install][numix] it. Cos this is a
dark theme, you'd better replace Inkscape's own icon set with that of
the [0.91 dark theme][ink-dark-theme]. Download the theme following the
link for the manual install, unzip, then

    $ mkdir -p ~/.config/inkscape/icons
    $ cp ~/Downloads/Inkscape\ 0.91\ dark\ theme/Set\ dark\ theme/share/icons/icons.svg ~/.config/inkscape/icons/

Once you're done with that, you may also want to have some basic OS X
integration as provided by this [app wrapper][ink-wrapper].

### Notes
1. **Stop gap solution**. Well, obviously! Hopefully at some point Cask
will update their Inkscape formula to 0.92 with native Quartz support.
As soon as they do, clean up all this mess and zap the Homebrew GUI tap
as it's been deprecated anyway.
2. **Homebrew automatically uninstalls Inkscape**! Next time you run *any*
`brew` command, Homebrew will update its repos and realise the Inkscape
formula got deleted from the Homebrew GUI tap. What happens next is an
automatic `uninstall --force` of Inkscape. Can't believe this is the
default behaviour, so think I'm quite likely to have screwed something
up...
3. **Updating/Reinstalling Inkscape**. If you need to do that, use the
(deleted!) Homebrew formula above. Also note there's no need to undo
and redo icons, theme, wrapper, and Inkscape config dir. Once the binary
is back in `/usr/local/bin` all the rest will work as before without
needing any intervention.
4. **Building a DMG**. The scripts and resources to build a DMG seem to
be in the Inkscape code base. So you could attempt building a DMG yourself
instead of installing from the Homebrew GUI tap. I've found [this gist]
[mk-native] that explains how to build a native GTK2/Quartz DMG. Haven't
tried it though, but might at some point as it should be easy to build
with GTK 3. (Looking at the Homebrew formula, it should be as simple as
setting a build variable.)




[homebrew-gui]: https://github.com/Homebrew/homebrew-gui
    "Homebrew GUI Tap"
[homebrew-gui-pr-47]: https://github.com/Homebrew/homebrew-gui/pull/47
    "Updated Inkscape to 0.92.0, added optional GTK+3 support"
[ink-dark-theme]: http://ioverd.deviantart.com/art/Inkscape-0-91-dark-theme-547919927
    "Inkscape 0.91 dark theme"
[ink-wrapper]: ../extras/Inkscape.app/README.md
    "Inkscape OS X Wrapper"
[mk-native]: https://gist.github.com/atuyosi/ab5499a176b0b456bca98c44e2775cbb
    "Buiding macOS Native (Gtk2/Quartz) version package."
[numix]: ../config/numix/README.md
    "Numix"
