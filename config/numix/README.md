Numix
=====
The [Numix Project][numix-home] guys design flat icons and themes for Linux. 
I dig their artwork! Some of their products are free, others you can buy for
very little. I've used some of their free goodies on Linux and even on OS X
to theme ported GTK apps like Inkscape. Specifically:

* [Numix Icon Theme][numix-icon-theme]: Base icons for GTK apps.
* [Numix Circle][numix-circle]: Includes the above as well as tons of app
icons for the GNOME Shell.
* [Numix GTK Theme][numix-gtk-theme]: GTK 3 theme with both light and dark
variants.


Installation
------------
The best option is to use a package manager. On OS X I couldn't find a 
Homebrew formula for any of the Numix artwork. But it's easy enough to
install stuff manually. In fact, here's a simple recipe to install the
base icon and GTK 3 themes as well as minimal GTK config to use them.
It works both on Linux and OS X.

First download and install the goodies:

    $ mkdir tmp && cd tmp
    
    $ curl -J -L -O https://github.com/numixproject/numix-gtk-theme/releases/download/2.6.5/Numix.zip
    $ unzip Numix.zip
    $ mkdir -p ~/.themes && mv Numix ~/.themes
    
    $ git clone https://github.com/numixproject/numix-icon-theme.git
    $ mkdir -p ~/.icons && mv numix-icon-theme/Numix ~/.icons
    
    $ cd .. && rm -rf tmp

Then make GTK 3 use both the theme and icons. GTK 3 user's config goes in
`~/.config/gtk-3.0/settings.ini`. For a minimal one look at this [ini file]
[numix-config].


Uninstalling
------------
Change your theme settings in `~/.config/gtk-3.0/settings.ini` to something 
else than Numix, then use your package manager to uninstall. If you've used
the above manual procedure to install, then:

    $ rm -rf ~/.icons/Numix*
    $ rm -rf ~/.themes/Numix*




[numix-circle]: https://github.com/numixproject/numix-icon-theme-circle
    "Numix Circle on Github"
[numix-config]: gtk-3.0/settings.ini
    "Minimal Numix Theme Configuration"
[numix-gtk-theme]: https://github.com/numixproject/numix-gtk-theme
    "Numix GTK Theme on Github"
[numix-home]: http://numixproject.org
    "Numix Project Home"
[numix-icon-theme]: https://github.com/numixproject/numix-icon-theme
    "Numix Icon Theme on Github"
