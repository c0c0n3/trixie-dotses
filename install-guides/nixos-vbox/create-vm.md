Creating the Virtual Machine
============================
> Steps to create madematix.

Create VM
---------
Create a VM in Virtual Box by clicking on the New button, then enter the
following values in the wizard screens.  (Note: the VM directory will be
created under the "Default Machine Folder"; this can be changed to e.g.
`/Volumes/data/VMs` in Virtual Box ➲ Preferences ➲ General.)

### Name and operating system
* Name: madematix
* Type: Linux
* Version: Other Linux (64 bit) 

### Memory size
* Memory size: 4096 (1/2 of physical RAM)

### Hard drive
* Create a virtual hard drive now
* VDI
* Dynamically allocated
* madematix.hd (make sure it goes in the VM's new folder created above)
* 50GB

VM Settings
-----------
Edit the virtual machine configuration in VirtualBox.

### General
* Advanced
  + Shared Clipboard: Bidirectional
  + Drag 'n Drop: Bidirectional

### System
* Motherboard
  + Boot Order: HD; deselect all others
  + Enable EFI
* Processor
  + Processors: 4 (1/2 of host cores)
  + Enable PAE/NX
* Acceleration
  + Paravirtualization Interface: KVM

### Display
* Screen
  + Video Memory: 128MB
  + Graphics Controller: VBoxVGA

###### Note
With Virtual Box `< 6`, if you set Graphics Controller to anything
else than "VBoxVGA", you'll end up with a black screen in your hands
when booting from the NixOS ISO or when booting NixOS itself after
installation! From version `>= 6`, there's a new "VMSVGA" setting
that's supposed to make things better. If I use that setting, then
booting goes smooth but then the actual host resolution isn't
available to the guest---it gets close but it's not the same which
makes my Nix HDMI tweaks go haywire...

### Audio
* Disable audio

Additional VM Settings
----------------------
These configuration items you can only set from the command line.

### Framebuffer Resolution
Set framebuffer resolution in EFI to `1920x1200`:

    $ VBoxManage setextradata "madematix" VBoxInternal2/EfiGraphicsResolution 1920x1200

See VirtualBox [manual][efividmode].

###### Note
On older versions of VirtualBox you should use `VBoxInternal2/EfiGopMode 5`
instead of `VBoxInternal2/EfiGraphicsResolution 1920x1200`.

### KMS Custom Mode
Make above resolution also available to Linux virtual consoles:

    $ VBoxManage setextradata "madematix" "CustomVideoMode1" "1920x1200x24"

See [Arch wiki][fb-resolution].




[efividmode]: https://www.virtualbox.org/manual/ch03.html#efividmode
    "Video modes in EFI"
[fb-resolution]: https://wiki.archlinux.org/index.php/VirtualBox#Set_optimal_framebuffer_resolution
    "Set optimal framebuffer resolution"
