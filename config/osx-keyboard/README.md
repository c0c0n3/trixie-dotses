OS X Keyboard Layouts
=====================

Keeping here a custom keyboard layout file for my laptop. Not using it at
the moment but may change my mind.

Details
-------
The file `default+greek+symbols.keylayout` defines a keyboard layout that
is exactly the same as the default U.S. layout but adds an extra layout on
top of it where the Greek alphabet and some maths symbols become available.
To have access to this additional layout you hit a modifier key. Then to type
a Greek letter you hit the corresponding English one: `a` for **α**, `b` for
**β**, `Shift+d` for **Δ**, and so on. For the maths symbols, I've tried to
map them to keys that (loosely) look like them---e.g. `.` for **◦**, `0` for
**∅**, `Shift+8` (`*`) for **×**.

I created the layout file using [Ukelele][ukelele] (version 2.2.8). To make
it available as an Input Source, you have to:

    $ cp default+greek+symbols.keylayout ~/Library/Keyboard\ Layouts/

Then you can select the corresponding keyboard in System Preferences →
Keyboard → Input Sources.

###### NOTES
Modifier key. I can't for the life of me remember which one it is. Best
thing to do is to open the layout file in Ukelele to find out.




[ukelele]: http://scripts.sil.org/ukelele
    "Ukelele Home"
