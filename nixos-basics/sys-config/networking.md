Networking
==========

* NixOS manual section: [Networking][nixos-man-net].
* Background reading: [Networking][arch-net] on the Arch wiki.


Minimal Settings
----------------
Wired network should work out of the box, but you'll probably have to tweak
wireless if you need it. Also, NixOS enables `dhcpcd` and IPv6 by default.
To set a local host name, use e.g.

    networking.hostName = "madematix";

Or set it to empty if the host name should rather come from a DHCP server.

### Notes
###### Local Host Name
NixOS hooks [nss-myhostname][nss-myhostname] into `systemd` to provide local
host name resolution. (To check it's enabled, run e.g. `grep my /etc/nsswitch`.)
This NSS module sort of makes `/etc/hosts` redundant, but Arch Linux still
[recommends][arch-hostname] adding a matching line in `/etc/hosts` for maximum
backward compatibility---see explanation [here][arch-hostname-res]. I doubt
you'll ever need to do this, but if something creeps up, here's an example
of adding the matching line Arch recommends to your NixOS config:

    networking.extraHosts = "127.0.1.1 madematix.localdomain madematix";




[arch-hostname]: https://wiki.archlinux.org/index.php/Installation_guide#Hostname
    "Installation Guide - Hostname"
[arch-hostname-res]: https://wiki.archlinux.org/index.php/Network_configuration#Local_network_hostname_resolution
    "Network Configuration - Local Network Hostname Resolution"
[arch-net]: https://wiki.archlinux.org/index.php/General_recommendations#Networking
    "Networking"
[nixos-man-net]: https://nixos.org/nixos/manual/index.html#sec-networking
    "Networking"
[nss-myhostname]: https://www.freedesktop.org/software/systemd/man/nss-myhostname.html
    "nss-myhostname"
