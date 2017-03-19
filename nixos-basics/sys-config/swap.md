Swap Space
==========

* Background reading: [Swap][arch-swap] on the Arch wiki.


Swap File
---------
You can use a file on your file system in place of a swap partition.
Here's an example of how to create a swap file of 1 GiB and tweak
"swappiness". (Example adapted from the [Arch wiki][arch-swap-file].)

    swapDevices = [{
        device = "/swapfile";
        size = 1024;    # size is in MiB
    }];

    boot.kernel.sysctl = {
        "vm.swappiness" = 1;
        "vm.vfs_cache_pressure" = 50;
    };

Note that if you don't specify the `size` attribute, then NixOS doesn't
create the swap file for you. In other words, if you had the following
instead:

    swapDevices = [{
        device = "/swapfile";
    }];

then you'd have to set up the swap file yourself before hand with

    $ sudo fallocate -l 1024M /swapfile
    $ sudo chmod 600 /swapfile
    $ sudo mkswap /swapfile
    $ sudo swapon /swapfile

but NixOS can run these commands under the hood for you if you specify
a `size`.




[arch-swap]: https://wiki.archlinux.org/index.php/Swap
    "Swap"
[arch-swap-file]: https://wiki.archlinux.org/index.php/Swapfile
    "Swap File"
