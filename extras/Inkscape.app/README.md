Inkscape OS X Wrapper
=====================
> Simple-minded MacOS app wrapper to execute Inkscape.


Purpose
-------
If you install Inkscape from the [homebrew-gui tap][ink-formula] through
Homebrew or you build it yourself without any OS X packaging support,
you'll end up with a fully functional Inkscape but you'll only be able
to launch it from the command line. This wrapper provides minimal OS X
GUI integration: icon, launchpad and dock-ability.


Installation
------------
Assuming you have already installed Inkscape and `inkscape` is in your
path, run the install script you'll find next to this README file:

    $ Inkscape.app/install

(You can run it from any directory you like.) The script will install into
`/Applications` but you can easily edit it to change the installation
directory.

### Notes
###### PATH Environment Variable
During installation we need to grab your `PATH` so that the `launcher`
script (see below) can later use it to start Inkscape. We assume the
Inkscape executable is in your PATH and is called `inkscape`.


Uninstalling
------------

    $ rm -rf /Applications/Inkscape.app


How it Works
------------
This wrapper comes with a minimal `Info.plist` that makes OS X run the
`launcher` script, provides an app icon, and registers Inkscape as an
SVG editor so that the Finder can add it to the "Open With" list shown
for SVG files.

The `launcher` script starts Inkscape. If an SVG file's currently selected
in the Finder, then it's passed as an argument to Inkscape. Otherwise the
script starts Inkscape with no arguments.

### Notes

###### App Icon
Lifted from Inkscape source (`packaging/macosx/Resouces`).
It shows nicely in the Launchpad but when you start the app what you get
in the Dock is whatever icon the underlying Inkscape executable has. If
that annoys you, change the executable's icon to be the one we have here.
(In Finder, "Get Info" on executable, make writable, copy & paste icon on
top left corner, restore read-only permission.)

###### Multiple Instances
Normally when you first click on an app's icon you get a new instance, but
if you click again you get back the already running instance. This is what
apps do on OS X, but I'd rather start a fresh Inkscape instance every time.
And this is exactly what the `launcher` script does. If you're not happy
with it, it's easy enough to change. (Look at the comments in the script.)

###### Python Launcher
I've ported the Bash `launcher` script to Python---see `python-launcher`.
Still needs a few tweaks but use it going forward if things get more
complicated. (E.g. add checks for different file types.) And as you're at
it, rewrite all the other bash scripts in Python. (Python ships with OS X,
so it's generally a better alternative to Bash, IMHO.)


Considerations
--------------
If this was half a decent wrapper, then you'd be able to do any of the
below:

1. If Inkscape can open a file type, then the Finder should show Inkscape
in the "Open With" list.
2. Selecting "Open With" Inkscape on a file Inkscape can open should open
that file in Inkscape. (d'oh!)
3. Starting Inkscape from the Launchpad or the Dock should create an empty
document.

But this wrapper is what it is, so

1. I've added an "Open With" option in the Finder *only* for SVG files.
2. So SVG is the only kind of file you can "Open With" Inkscape from the
Finder.
3. Starting Inkscape from the Launchpad or the Dock creates an empty
document as long as *no SVG file is currently selected* in the Finder.
If you have an SVG file selected, then Inkscape opens that file.


Alternatives
------------
Use Automator to create an App wrapper that runs a shell script, e.g.

    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
    open -n -a $(which inkscape) --args $@

Where the PATH value is that of your shell. You need to select the "Pass
input as arguments" option in the Automator form. This way when you do an
"Open With" Inkscape on a file in the Finder, the file path is correctly
passed in as an argument to the script and so on to Inkscape. If you then
edit the generated `Info.plist` to add Inkscape supported file types, you
get a wrapper that fulfils points 1 to 3 above. And as you're at it, why
not replace the generated bundle's icon with the Inkscape icon?




[ink-formula]: https://github.com/Homebrew/homebrew-gui/blob/master/inkscape.rb
    "Inkscape formula from homebrew-gui"
