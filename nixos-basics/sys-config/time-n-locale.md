Time & Locale
=============

Locale
------
Set it with e.g.

    i18n.defaultLocale = "en_GB.UTF-8";


Time
----
Background reading: [Time][arch-time] on the Arch wiki.

### Setting the Time Zone
[Look up][wikipedia-tz] your time zone and then set it with `time.timeZone`,
e.g.

    time.timeZone = "Europe/Paris";

### Notes
###### Hardware Clock
NixOS uses UTC by default. (According to the docs, the default value of
`time.hardwareClockInLocalTime` is `false`.) In the past I've used

    $ hwclock --systohc --utc

at installation time, but note that TLDP says you shouldn't need to run
this command on modern distros---see [here][tldp-time].




[arch-time]: https://wiki.archlinux.org/index.php/Time
    "Time"
[tldp-time]: http://www.tldp.org/HOWTO/TimePrecision-HOWTO/set.html
    "Managing Accurate Date and Time - The Correct Settings for Your Linux Box"
[wikipedia-tz]: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    "List of tz database time zones"
