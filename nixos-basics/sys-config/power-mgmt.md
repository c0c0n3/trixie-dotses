Power Management
================

Couldn't find much on this topic in the NixOS manual besides the fact you
can use `systemctl suspend` and `systemctl hibernate` to suspend to RAM
and to disk, respectively. So, yep, NixOS must be using `systemd` for power
management. Looks like if you need to know anything about power management,
you'd better head over to the [Arch wiki][arch-pow-mgmt]...


Hibernation
-----------
If you want it, you need to have either a swap partition or a swap file.
Then you have to set some kernel params. (`resume` with a partition or
`resume_offset` if you're using a swap file.) Read more about it on the
[Arch wiki][arch-pow-mgmt-hibernate].




[arch-pow-mgmt]: https://wiki.archlinux.org/index.php/Power_management
    "Power Management"
[arch-pow-mgmt-hibernate]: https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate
    "Suspend and Hibernate"
