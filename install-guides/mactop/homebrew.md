Homebrew+Cask
=============

I'm using [Homebrew][brew] and [Cask][cask] to manage apps. They let me
easily install, upgrade, and uninstall apps.


Installation
------------
### Homebrew

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Stop Homebrew from sending out data for analytics:

    $ brew analytics off

###### Note
Lots of Homebrew formulas depend on the XCode Command Line Tools so the
installer will prompt you to install them.

### Cask

    $ brew tap caskroom/cask

Bring in the fonts Cask too (see [usage docs][cask-additional-taps]):

    $ brew tap caskroom/fonts


Usage
-----
Use Homebrew for CLI apps and Cask for GUI's. To find out more about them 
you should read the docs, but here's a blog [post][brew-cheat-sheet] with 
a neat cheat sheet for Homebrew as well as suggested workflow---short and
sweet!

### Gotchas

###### XCode
I'm okay with installing the CLI tools (only 150 MB) but don't wanna bring
down (and then having to update) that humongous beast (> 4 GB!) of XCode.
So beware: **some formulas require the whole of XCode, avoid them like the
plague!**

###### Cleaning up
Homebrew and Cask keep old packages around in a cache directory (`brew --cache` 
shows it) and the cache may grow big over time. You should run these cleanup
commands regularly (consider setting up a `launchd` scheduled job):

    $ brew cleanup -s
    $ brew cask cleanup

The first one removes old versions of Homebrew formulas both from the cellar
and the download cache but will still keep around downloads for the latest
versions of the currently installed formulas. The second command makes Cask
do the same. In any case, you always have an option to nuke the whole cache:
`rm -rf $(brew --cache)`.

###### Uninstalling
When I uninstall something, I usually wanna zap the whole thing, config
included. For a formula installed through Homebrew use

    $ brew uninstall --force formula_name
        
Note that without the `force` option, Homebrew won't remove old versions
of the formula and, if you do an upgrade (`brew upgrade --all`) before a
cleanup, it'll reinstall the formula's newest version it knows about!
Cask seems to have a better option to purge a formula:

    $ brew cask zap formula_name

From the man page: "Unconditionally remove all files associated with the 
given Cask. Implicitly performs all actions associated with uninstall
[...] If the Cask definition contains a zap stanza, performs additional
zap actions as defined there, such as removing local preference files.
[...] zap may remove files which are shared between applications."




[brew]: http://brew.sh
    "Homebrew Home"
[brew-cheat-sheet]: http://blog.shvetsov.com/2014/11/homebrew-cheat-sheet-and-workflow.html
    "Homebrew cheat sheet and workflow"
[cask]: https://caskroom.github.io
    "Cask Home"
[cask-additional-taps]: https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md#additional-taps-optional
    "Cask Usage: Additional Taps"
