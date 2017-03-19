IntelliJ IDEA Settings
======================

> IDEA settings I'm using for Java development.


Theme
-----
Been using Solarized colour scheme on [GitHub][solarized-theme].
Clone or download the repo, then install using "Import Settings..." as
explained in the [README][solarized-theme]. The theme name is "Solarized
Dark (Darcula)". (You can nuke the downloaded files after importing.)

You should set up this theme before importing the settings below 
(`settings.jar`) cos they tweak the theme's keyword highlight colours IIRC.


Basic Configuration
-------------------
This directory contains the config files I originally grabbed from my Linux
installation. (The IDEA version I had was **IdeaIC2016.1**.)

* `settings.jar`. Settings exported from the IDE (*File ➲ Export Settings*).
* `inspectionProfiles`. The Java inspection profile I've been using for
Smuggler. I manually copied the whole directory out of the IDEA's project
directory (`ome-smuggler/.idea/inspectionProfiles`.)

All of the above seems to work equally well in my IDEA on OS X. You can
import `settings.jar` directly into the IDE but you'll need to copy
yourself `inspectionProfiles` into your project directory as these are
project-specific settings.


Java JDK
--------
IDEA comes with its own JDK which you can set up as the project JDK if you
don't want to install Java on your box.




[solarized-theme]: https://github.com/jkaving/intellij-colors-solarized
    "Solarized Color scheme for IntelliJ IDEA"
[solarized-theme-opt-1]: https://github.com/jkaving/intellij-colors-solarized#option-1-install-using-import-settings
    "Install using 'Import Settings...'"

