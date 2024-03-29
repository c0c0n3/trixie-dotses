My Spacemacs
============

This directory contains my Spacemacs configuration. All you need to know about
it is in the below sections.


Why?
----
Why using Spacemacs instead of Emacs? My reasons:

* It's just an Emacs streamlined configuration. That's it. No separate program,
just install Emacs and make it use Spacemacs config. (Or I could even switch
back to my old Emacs config if I really wanted to!)
* Curated, tuned packages nicely organised in config layers. Just include the
layer you want to use (e.g. `haskell`, `markdown`) and it mostly works out of
the box. Avoids me having to do the configuration myself, i.e. write code I'll
then have to *maintain*.
* Managed updates. Manages its own updates and also lets you update installed
packages.
* Streamlined, discoverable key bindings. Just hit `M-m` to find stuff. Much
better than the window's menu bar.


Installation
------------
Install Emacs first. Then:

    $ mv ~/.emacs.d ~/.emacs.d.bak
    $ mv ~/.emacs ~/.emacs.bak
    $ git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    $ cp -r /path/to/this/.spacemacs.d ~/

Note that you can't use any existing Emacs config. But you can restore it later
if you want to switch back to it. Also, you can sym-link this repo's
`.spacemacs.d` into your home instead of copying it.

#### Default font
Spacemacs uses "Source Code Pro" as default font. I use that too in my config,
so install it or change the font settings, see below.

#### Spacemacs version compatibility
It looks like Spacemacs sort of adopts a rolling release model these
days. In fact, point releases used to come off the `master` branch, but
this branch hasn't got any updates in ages and the `develop` branch,
where all the action takes place, has become the default branch on GitHub.
So when you clone with

    $ git clone https://github.com/syl20bnr/spacemacs

as documented in the official install instructions, what you get is actually
the latest of `develop`. Will my config in `.spacemacs.d` still work
with the Spacemacs code you check out at some time in the future? Dunno.
But if something breaks and you don't want to fix it, just go back to
the the same `develop` commit I tested with:

- https://api.github.com/repos/syl20bnr/spacemacs/commits/3875f7a2fdef2f7373a1f01622dc228b1ed2b534

To do that quickly, just

    $ cd ~/.emacs.d
    $ git checkout 3875f7a2fdef2f7373a1f01622dc228b1ed2b534

but keep in mind your Spacemacs repo is now in a [detached head][git.det-head]
state.


Usage
-----
I have three Spacemacs configuration sets: the one for the Emacs editor
proper and the other two for Emacs terminal emulators. The `SPACECONF`
environment variable controls what set Spacemacs will use:

* `SPACECONF=editor`: Spacemacs editor.
* `SPACECONF=terminal`: Similar config to the editor but automatically
starts `ansi-term`.
* `SPACECONF=etermd`: Same as the terminal but tweaked to work with an
Emacs daemon.

If this variable is unset or set to anything else than the above, then
running `emacs` starts Spacemacs with the editor configuration. Note that
`etermd` brings up Spacemacs with the terminal config set but with no open
terminal buffer. This is handy if you want to run an Emacs daemon just to
open terminal buffers pronto, e.g.

    $ SPACECONF=etermd emacs --daemon="etermd" &
    $ emacsclient -c -s "etermd" -e '(ansi-term "bash")'

Obviously if you do this, you may want to set up things a bit more decently,
e.g. a `systemd` user unit for the daemon, a wrapper client script, etc.

### Spacemacs init
The way Spacemacs finds your config is by first looking at a `~/.spacemacs`
file and, failing that, it tries `~/.spacemacs.d/init.el`. Alternatively,
you can define a `SPACEMACSDIR` environment variable to point to your
Spacemacs config dir. Our config works with a `~/.spacemacs.d/init.el`
file, so you should have no `~/.spacemacs` or `SPACEMACSDIR` and should
have copied (or sym-linked) the directory containing this README to your
home---see Installation section above.

### Spacemacs theme
Theme settings are in `editor/theme.el`. One thing you may want to tweak
is the font, especially the size. You can do this by directly editing the
theme file or by setting the `SPACEFONT` environment variable to a font
spec in the format `dotspacemacs-default-font` expects, e.g.

    SPACEFONT="'(\"Monaco\" :size 16)"
    SPACEFONT="'(\"Source Code Pro\" :size 18 :weight light)"

### Spacemacs layers
The editor config set loads some Spacemacs layers that I use often. The
corresponding config stanza sits in `editor/layers.el`. If you want to
load a different set of layers within the editor config set, define a
`custom-layers` function and put it in `~/.spacemacs.layers.el`. Have a
look at `editor/layers.el` for the details.

Notice `editor/layers.el` configures [Treemacs][treemacs] and adds a
`navbar` interactive function to bring up a Treemacs window with just
a project for the current directory in it as opposed to the default
workspace and projects:

    $ cd my/proj/root
    $ emacs . &
    (Emacs) M-x navbar

But keep in mind `navbar` replaces all the projects in your current
Treemacs workspace with a project for the current directory. Fully-fledged
workspaces are actually much more useful, [check them out][treemacs]!


Configuration Organisation
--------------------------
The editor configuration set sits in the `editor` directory, the terminal
config in `terminal` and the daemon-friendly one is in `etermd`.
The top-level `init.el` is what Spacemacs loads. This script just loads
one of the configuration sets depending on `SPACECONF`. In turn each config
set has its own `init.el` to define the config hooks Spacemacs expects:
`layers`, `init`, `user-config`, etc. I've arranged most of the settings
in configuration groups (frame, editing, etc.) and put each group in its
own file. Each of these files provides suitable `init`, `user-config`, etc.
functions I call from the Spacemacs hooks in the config set's `init.el`.
This way I can organise my config options better cos I can modularise the
settings.

### Initial Spacemacs configuration
I generated an initial Spacemacs config file by launching Spacemacs with
no config and selecting the Holy mode option (Emacs editing style) and the
default Spacemacs distribution bundle (`spacemacs`) when prompted. Then

    $ mkdir ~/.spacemacs.d
    $ mv  ~/.spacemacs ~/.spacemacs.d/.spacemacs.original
    $ cp ~/.spacemacs.d/.spacemacs.original ~/.spacemacs.d/init.el

and started hacking away on `~/.spacemacs.d/init.el` to split the settings
into groups (frame, editing, etc.) and then moved them in their own files.
I'm keeping `.spacemacs.original` exactly as Spacemacs spit it out for
future reference, should any Spacemacs config option change.


Issues
------
There are some annoyances, but nothing I can't live with.

#### Performance
Spacemacs takes a couple of seconds to start up. This is no problem when I
launch the editor, but it's sort of annoying when starting the terminal
emulator (i.e. Spacemacs started with `terminal/init.el`) as I'd like it to
be as snappy as in my old config. Excluding packages improves startup times
just slightly, see `terminal/init.el`. Of course you could always use an
Emacs daemon, but sometimes setting the whole server/client thing up is
just overkill. (Well, it's quite a bit of work if you want to have a
proper, robust, and flexible set up, unlike the one we've sketched
out earlier!)

#### Smooth scrolling
Seems to cause sluggish performance on my Ubuntu workstation after a few
hours of editing. No noticeable issue in my Arch Linux VM though...

#### Transparency
Active/inactive transparency settings seem to have no effect. See `frame.el`
and `terminal\frame.el`. Switching themes in the terminal emulator (i.e.
Spacemacs started with `terminal/init.el`) causes transparency issues.

#### Spacemacs buffer
Could not find a clean way to inhibit it. See notes in `frame.el` and
`terminal\frame.el`.




[git.det-head]: https://git-scm.com/docs/git-checkout#_detached_head
    "git-checkout Documentation - Detached head"
[treemacs]: https://github.com/Alexander-Miller/treemacs
    "Treemacs - a tree layout file explorer for Emacs"
