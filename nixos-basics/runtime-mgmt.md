Runtime Management
==================
> Managing a running system.


System and Service Management
-----------------------------
NixOS's init system is [systemd][systemd]. A "unit" is some resource
`systemd` manages: a daemon (service), a device, a mount point, etc.
Each unit has a configuration file to tell `systemd` what to do with
the resource and its dependencies. `systemctl` is the basic tool you
use to introspect and control your box. For example

    $ systemctl                    # status of active units
    $ systemctl --failed           # list failed units
    $ systemctl status unit        # detailed status and logs of unit

Besides the `status` command above, other common commands to control
units are: `start`, `stop`, `restart`, `enable`, `disable`. For example
you could

    $ sudo systemctl restart some.service

There are common power management commands too such as `suspend`,
`hibernate`, `reboot`, and `poweroff`:

    $ sudo systemctl suspend
    $ sudo systemctl reboot

Other basic tools that come with `systemd` are

* `loginctl` for [user sessions][nixos-loginctl].
* `systemd-cgls` for [control groups][nixos-systemd-cgls].
* `journalctl` for the [logs][nixos-logs].

Read more about `systemd` on the [Arch wiki][arch-systemd].


NixOS Containers
----------------
NixOS comes with light-weight OS virtualization that lets you run another
NixOS instance at native speed inside a container. The NixOS manual has a
guide to [container creation and management][nixos-containers].




[arch-systemctl]: https://wiki.archlinux.org/index.php/Systemd#Basic_systemctl_usage
    "Basic systemctl Usage"
[arch-systemd]: https://wiki.archlinux.org/index.php/Systemd
    "systemd"
[nixos-containers]: https://nixos.org/nixos/manual/index.html#ch-containers
    "Container Management"
[nixos-systemd-cgls]: https://nixos.org/nixos/manual/index.html#sec-cgroups
    "Control Groups"
[nixos-loginctl]: https://nixos.org/nixos/manual/index.html#sec-user-sessions
    "User Sessions"
[nixos-logs]: https://nixos.org/nixos/manual/index.html#sec-logging
    "Logging"
[systemd]: https://en.wikipedia.org/wiki/Systemd
    "systemd"
