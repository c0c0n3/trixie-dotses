System Preferences
==================

Below are the system preferences I manually entered using the built-in 
System Preferences app.

General
-------
* *Appearance*: light
* *Highlight color*: FFBEB4

###### Note
In Mojave the colour will look dimmer than in the previous macOS's---probably
Mojave introduced some L&F changes and the highlight colour value gets rendered
on screen with an alpha value less than 100%.

Desktop & Screen Saver
----------------------
* *Desktop*: choose wallpaper from Trixie Dotses repo
* *Screen Saver*: Classic; *Source*: Sierras
* *Screen Saver ➲ Start After*: 10 min

###### Notes
1. Trixie Dotses repo. It should be on the `data` partition. Add this path
to *Folders*: `/Volumes/data/github/trixie-dotses/wallpapers`.
2. National Geographic screen saver. Apparenlty Mojave
[ditched it][nat-geo-screen-saver] it. You can still get the pics from the
interwebs though, put them in a folder and add that folder to the screen
savers.

Dock
----
* *Magnification*: 3/4 of the way
* Automatically hide and show the Dock
* Don't show recent applications in Dock

Mission Control
---------------
Add another three desktops (total of four)

Language & Region
-----------------
* *Region*: United Kingdom
* *Preferred languages*: English (U.K.) --- Primary

###### Note
Setting the region to South Africa and the language to "English (South
Africa)" results in no `LANG` environment variable being set, whereas
the setting above gives `LANG=en_GB.UTF-8`. Didn't have time to find
out if not having `LANG` set is a bad thing, so I'd rather keep it like
this for now.

Screen Time
-----------
Disable entirely.

Security & Privacy
------------------
* *General*: turn off screen lock (disable: *Require password*)
* *FileValut*: off
* *Firewall*: off
* *Privacy ➲ Location Services*: off
* *Privacy ➲ Analytics*: don’t send any data (disable all)

Displays
--------
* *Display*: disable Show mirroring options.

Keyboard
--------
* *Keyboard*: turn off automatic backlighting (disable: *Adjust keyboard
brightness in low light*)
* *Keyboard*: Show keyboard and emoji viewers in menu bar
* *Shortcuts ➲ Mission Control*: enable all *Move space* and *Switch to
Desktop* shortcuts
* *Input Sources*: U.S.

Trackpad
--------
* Tap to click

iCloud
------
Turn off completely (disable all features and then sign out) if you don't
need to share files with your iPad. Otherwise:

1. Unckeck all features except for *iCloud Drive*.
2. *iCloud Drive ➲ Options ➲ Documents*: unckeck all apps.

Sharing
-------
Set computer name to `cocone` and disable all sharing. 

Users & Groups
--------------
Only one admin user (username: andrea); disable built-in Guest User.

Siri
----
Disable.

Time Machine
------------
Disable automatic backup.

Accessibility
-------------
*Mouse & Trackpad ➲ Trackpad Options ➲ Enable dragging*: three finger drag




[nat-geo-screen-saver]: https://discussions.apple.com/thread/8630718
    "National Geographic Screen Saver Missing"
