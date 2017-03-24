NixOS Guest Installation
========================
> Steps to install madematix guest.


Install NixOS Core
------------------

### Mount NixOS ISO
In VM *Settings ➲ Storage ➲ Optical Drive*

* Chose Virtual Optical Disk File (click on little CD icon and browse to
and browse to downloaded NixOS ISO)
* Live CD/DVD: enable

### NixOS Installation
Do installation as detailed in [NixOS Core][core-install]. When prompted,
enter root password: `abc123`. After installer's finished, `poweroff`.

### Unmount NixOS ISO
In VM *Settings ➲ Storage ➲ Optical Drive*

* Remove Disk from Virtual Drive (click on little CD icon)
* Live CD/DVD: disable


Additional VM Settings
----------------------
In VM *Settings ➲ Shared Folders*, add

    /Volumes/data/VMs/dropbox
    /Volumes/data/github
    /Volume/data/playground
    /Volumes/data/projects

Do *not* enable auto-mount. Also make sure directory names match those
declared in `ext.vbox-shares.names` or the system will fail to start.


NixOS Guest Setup
-----------------

### Bootstrap

    $ cd /etc/nixos
    $ nano configuration.nix   # add git to environment.systemPackages
    $ nixos-rebuild switch
    $ git clone https://github.com/c0c0n3/trixie-dotses.git
    $ mv configuration.nix initial.configuration.nix.bak
    $ ln -s /etc/nixos/trixie-dotses/config/nixos/boxes/madematix/default.nix configuration.nix

### Build madematix

    $ nixos-rebuild switch

### Post-build
The Emacs terminal daemon won't start until Spacemacs has downloaded all
the packages. So log in and start Emacs (GUI) then reboot.




[core-install]: ../../nixos-basics/core-install/README.md
    "NixOS Core"
