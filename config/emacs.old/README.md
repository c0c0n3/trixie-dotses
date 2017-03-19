My Old Emacs Configuration
==========================
Saving my old Emacs config (`.emacs*` files) in this directory.
This is the config I used up to May 2016 and I'm keeping it around for future
reference if I decide to ditch Spacemacs.

Notes
-----
1. If using this config again, check the various bits and pieces are still
current and see if there are better ways to do that kind of stuff.
2. The `.emacs.d/terminal*` files I used to configure a standalone terminal
hooked into Xmonad and called with this command:

    emacs -q -l /home/andrea/.emacs.d/terminal.el -e ansi-term

This avoided me to use a dedicated terminal emulator such as rxvt-unicode
with the added configuration burden.
