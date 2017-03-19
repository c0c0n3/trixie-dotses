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
* 20GB

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
  + Use Unscaled HiDPI Output

### Audio
* Disable audio

Additional VM Settings
----------------------
These configuration items you can only set from the command line.

### Framebuffer Resolution
Set framebuffer resolution in EFI to `1920x1200`:

    $ VBoxManage setextradata "madematix" VBoxInternal2/EfiGopMode 5

See VirtualBox [manual][efividmode].

### KMS Custom Mode
Make above resolution also available to Linux virtual consoles:

    $ VBoxManage setextradata "madematix" "CustomVideoMode1" "1920x1200x24"

See [Arch wiki][fb-resolution].




[efividmode]: https://www.virtualbox.org/manual/ch03.html#efividmode
    "Video modes in EFI"
[fb-resolution]: https://wiki.archlinux.org/index.php/VirtualBox#Set_optimal_framebuffer_resolution
    "Set optimal framebuffer resolution"
