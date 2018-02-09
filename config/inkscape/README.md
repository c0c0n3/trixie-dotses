Inkscape Set Up
===============

Files in this directory are used to configure Inkscape for drawing maths
notes. I'll be using `$CONFIG_DIR` to refer to the Inkscape user's
configuration directory. On Linux, this is usually:

    ~/.config/inkscape/

And this is the the default location on OS X as well if you installed
Inkscape as a vanilla port, e.g. through Homebrew or Mac Ports. On the
other hand if you used a `dmg` installer, the configuration directory
is likely to be:

    ~/Library/Application\ Support/org.inkscape.Inkscape/inkscape/


doc-templates
-------------
Document templates to determine initial doc properties---i.e. what can be
specified in the `File -> Document Properties` dialog. You can create one
by opening a new document, setting the desired props in the dialog then 
saving the file to:
  
    $CONFIG_DIR/templates/

The template will appear in the `File -> New from Template` dialog.

`doc-templates` contains my templates; they should be copied over to the
above directory before they can be used, obviously.

Also, if a `default.svg` template exists in the above `template` directory,
it will be used for new documents when Inkscape starts. So make a sym link
to point to the template to use for new docs, e.g.

    $ cd $CONFIG_DIR/templates/
    $ ln -s Blackboard.svg default.svg


palettes
--------
Colour palettes, should go into:

    $CONFIG_DIR/palettes/

Here are the palettes I've used overtime for all diagrams having either
dark or white background.

* `echo-palette.gpl`: Echo Icon Theme palette which ships with Inkscape 0.91.
* `solarized+echo.gpl`: joined Echo Icon Theme with Solarized palette; so I 
stopped using Echo and used this instead for some time.
* `pastel.gpl`: Pastel colours palette; the one I'm using at the moment in
place of the two above. See comments in palette file for more info about the
colours.


preferences
-----------
Preference files to specify tools props. 

* `blackboard.preferences.xml`: set up to go with Blackboard documents.
* `white-bg.preferences.xml`: set up to go with white background docs.

to install one preference set, override:

    $CONFIG_DIR/preferences.xml

(Make a backup first!)

Note that this is convenient but it may stop working with future Inkscape
versions if the configuration schema changes.
So for the record, this is how to specify the exact same settings in the
preference files through the preferences dialog instead. (The dialog will
write the settings to `$CONFIG_DIR/preferences.xml` along with alot of
junk whereas our XML files are clean and tidy.) The colour names mentioned
below are those of the Pastel palette.

* **palette**. select Pastel palette with a size of tiny. 
* **calligraphy**. draw something; select it; set stroke=none, fill=Grey 3 
(white bg) or Grey 2 (blackboard bg); take calligraphy tool style from 
selection.
* **preset calligraphy: my-marker**. draw something; add new calligraphy 
preset called "my-marker" with: width=3, angle=90, mass=2, cap rounding=1,
all other params=0.
* **preset calligraphy: my-pen**. draw something; add new calligraphy preset 
called "my-pen" with: width=4, angle=45, fixation=80, mass=2, all other 
params=0.
* **preset calligraphy: my-calligraphy**. draw something; add new calligraphy
preset called "my-calligraphy" with: width=10, thinning=20, angle=30, 
fixation=100, mass=2, all other params=0.
* **rectangle tool**. draw rectangle; select it; set fill=none, stroke=Grey 2; 
Rx=Ry=8; take rectangle tool style from selection. 
* **font**. enter some text; select it; set size=16pt, fill=Grey chateau,
family=KG Miss Speechy IPA; take font style from selection.

###### Notes
1. **Font Families**. Fonts I've used so far in diagrams: Chalkboard, 
Architects Daughter, KG Miss Speechy IPA, Sansita One.
2. **Blackboard v White BG prefs**. The two files are identical, except for
the calligraphy colour.


symbols
-------
Symbol libraries. They go into

    $CONFIG_DIR/symbols
    
The directory usually doesn't exists, so

    $ mkdir -p $CONFIG_DIR/symbols

Then copy over `letters-and-numbers.svg`. (This is the only lib I've used
so far, the others are just experiments.)

Additionally you can download SVG symbol libs from the interwebs. Make sure
to add a `title` tag to the SVG doc so that it shows in the Inkscape symbols
drop down menu. (See `letters-and-numbers.svg` for an example.)
One place where you can find nice icons is [svg-icon][svg-icon]. I've used
the `font-awesome` and `logos` sets in the past.


[svg-icon]: https://leungwensen.github.io/svg-icon/
    "svg-icon"
