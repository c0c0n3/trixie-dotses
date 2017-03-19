Users & Groups
==============

* NixOS manual section: [User Management][nixos-man-usr-mgmt].
* Background reading: [users and groups][arch-usr-n-groups] on the Arch wiki.


Declarative User Management
---------------------------
This Nix expression keeps the contents of `/etc/passwd` and `/etc/group`
in sync with your NixOS config spec:

    users.mutableUsers = false;

Now adding/removing users to/from your spec will add/remove them to/from
the system as well. This value is `true` by default, which means you can
add users to your spec and later change them using command line tools.
Be careful with setting this value to `false`: if you do, then your spec
should also include users the NixOS installer created for you, e.g. the
`root` user.


Adding a User
-------------
This Nix expression adds a regular user named `andrea`, makes him a member
of `wheel`, and sets his password to `abc123`:

    users.extraUsers.andrea = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$DmW6Owb/Swuzs7$DKca.vHGUP3bTz/G5vae4/egALZVVdsGdkhzISU11ZsFy2jmMVkZtIwTbNzK5cau9AOmb2B4LTd6BxcOKR1oW1";
    };

Setting the `isNormalUser` option to `true` implicitly:

* adds `andrea` to the `users` group;
* creates `/home/andrea` (use the `home` option to specify a different home);
* makes `andrea` use the default shell (Bash).

The value of `hashedPassword` is the SHA-512 hash of `abc123`.

### Notes
###### Admin Account
Members of the `wheel` group have admin privileges and can use `sudo` to
run commands as `root`.

###### Generating Hashed Passwords
To generate hashed passwords to go in your users config expressions, use
the `mkpasswd` command. (It's not installed by default, so you'll have to
install it yourself.) For example, running

    $ mkpasswd -m sha-512

and then entering `abc123` when prompted, spits out on `stdout` the hash
used in the example above.




[arch-usr-n-groups]: https://wiki.archlinux.org/index.php/Users_and_groups
    "Users and Groups"
[nixos-man-usr-mgmt]: https://nixos.org/nixos/manual/index.html#sec-user-management
    "User Management"
