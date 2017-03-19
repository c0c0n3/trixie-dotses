Security
========

* Background reading: [Security][arch-sec] on the Arch wiki.


Admin Account
-------------
You already have a `root` account created by the installer. Additionally,
the installer also set up a standard `wheel` group. Any member of this
group has admin privileges and can use `sudo` to run commands as `root`.


Power Management
----------------
A regular user (i.e. one created with `isNormalUser = true`) can run
power-management commands (`poweroff`, `reboot`, `systemctl suspend`,
etc.) without admin authorisation. For example, being logged in as a
non-sudoer, just a plain

    $ reboot

would cause a system reboot.

###### Note
Didn't have time to find out why this works, but my guess is that NixOS
uses [Polkit][arch-polkit] to do that. See also the Arch wiki on [allowing
users to shutdown][arch-allow-shutdown].


sudo
----
[sudo][arch-sudo] is enabled by default. (See `security.sudo.enable`.)
You can use `security.sudo.extraConfig` to append lines to `sudoers`.
NixOS will run `visudo` to check these lines are syntactically valid.
For example,

    security.sudo.extraConfig = ''
        andrea ALL=(ALL) ALL
        andrea ALL=NOPASSWD: /run/current-system/sw/bin/systemctl reboot
    '';

gives the user `andrea` admin super powers (first line) and lets him run
`sudo systemctl reboot` without asking for a password (second line). This
one takes it a step further

    security.sudo.extraConfig = ''
        andrea ALL=(ALL) ALL
        Defaults:andrea !authenticate
    '';

as now `andrea` is still an admin (first line) but is not required to enter
a password when using `sudo` (second line). You can do something similar
with

    security.sudo.wheelNeedsPassword = false;

but this will allow any member of `wheel` to `sudo` without a password.




[arch-allow-shutdown]: https://wiki.archlinux.org/index.php/allow_users_to_shutdown
    "Allow users to shutdown"
[arch-polkit]: https://wiki.archlinux.org/index.php/Polkit
    "Polkit"
[arch-sec]: https://wiki.archlinux.org/index.php/Security
    "Security"
[arch-sudo]: https://wiki.archlinux.org/index.php/Sudo
    "Sudo"
