Trixie dotses
=============
> dot files and other badness for my preciousss ring of (de-)vices!

Idea
----
One repo to rule all my dot files, one repo to find them, one repo to bring them
all and in the darkness bind them. Keep as much stuff as you need to be able to
set up each device from scratch: dot files, scripts, docs, pics, whatever you
need. Automate the process as much as you can. Clone this repo on each device
and use `git` to manage config changes.

In This Repo...
---------------
The `config` directory is where I keep all dot files and other config items
for the apps I use. In there you'll see a directory for each app I care
saving config settings with the corresponding files and a README to explain
how to use them. On my Mactop configuration is pretty much manual, but I
let Homebrew take care of much of the rest---see my [Mactop Installation
Guide][mactop]. I run NixOS on all my other boxes and use Nix expressions
to automate almost all of the machine building and configuration. In fact,
I have a bunch of Nix scripts and modules in [config/nixos][nixos] and a
[short guide][nixos-vm] on how to use them to build the NixOS VirtualBox
VM I keep on my Mactop. I've also recorded much of what I've learnt about
Nix and NixOS just in case it could be useful to someone else out there:
[NixOS Basics][nixos-basics] is a short survival guide with all the stuff
I've found useful as a *starting point* to be able to build, run and keep
a NixOS system in good shape.

Configuration
-------------
You can install config files by simply copying them over to wherever they're
supposed to sit on your box. But in most cases it's best to (`git`) clone
this repo to your box and then sym-link files so that you can easily track
any changes you make and get updates from upstream. For example, you could
install Spacemacs config by a simple

    $ ln -s /path/to/trixie-dotses/config/.spacemacs.d ~/.spacemacs.d

and then use `git` to manage local and remote changes as you see fit. On
NixOS, the extension modules in `config/nixos` automate much of the process,
including the sym-linking of dot files.

Workflow
--------
Like I said, if you care about some config items, stash them away in the
`config` directory. Oh, don't forget to add a README too! If it's a file
you can use on different devices, then keep the Mac specific version in
`config` and use Nix to massage the file into the other devices. (See e.g.
what I've done with Spacemacs default font.) To configure a device, first
clone this repo on it and then use Nix or your bare hands to install the
settings. When you change some settings on a device, do it in the cloned
repo so you can track changes and push them back to Github. Then when you
switch to another device, just pull from Github to get the new settings.

### Device Branches
I used to have a branch for each device, sharing content among branches as
much as possible. The master branch would only contain config, docs, etc.
that can be shared across device branches---e.g. Spacemacs config. Device
branches would only tweak master files---e.g. change font settings in
Spacemacs config. Also each device branch would have a bunch of other files
specific to that device's set up---e.g. a doc detailing installation steps.
Development of core content would always be done in master---e.g. add new
features to Spacemacs config. Then it would be merged into each and every
device branch. But device branches would never be merged into master.

It turned out to be a huge pain in the backside. If I wanted to change a
shared setting I first had to check out master, make the change, push to
Github, propagate to all device branches, then pull the device branch
locally to get the updated setting. So I'd only consider this model again
if I end up with configuration sets that can't be easily managed with Nix
or some kind of templating mechanism.




[mactop]: install-guides/mactop/README.md
    "Mactop Installation Guide"
[nixos]: config/nixos/README.md
   "My NixOS Scripts"
[nixos-basics]: nixos-basics/README.md
    "NixOS Basics"
[nixos-vm]: install-guides/nixos-vbox/README.md
    "NixOS VirtualBox VM"
