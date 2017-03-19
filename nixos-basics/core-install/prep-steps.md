Prep Steps
==========
> Setting the stage.


Boot NixOS Installer
--------------------

### Format USB Stick
All UEFI firmware can mount FAT32, so format the USB with FAT32. FAT
[volume labels][volume-label] should be 11 bytes long, use alphanumeric
ASCII chars, and are stored in uppercase. So give the stick a name of
e.g. "NIXOS_ISO  ". Note padding spaces to get to 11 chars. (According
to [this][usb-label] weird stuff can happen if you have less than 11.) 

### Download and Burn ISO
[Download][nixos-download] the minimal installation CD. (Hey, don't forget
to check the SHA-256 hash!) After downloading, use `dd` to burn the ISO on
the USB stick following the instructions on the [Arch wiki][arch-usb-iso].

### Configure Firmware
Boot your box and get into the firmware configuration utility. Enable

* Booting from USB.
* Booting in **UEFI mode**.

If you don't enable UEFI mode *before* booting into the NixOS image, the
installer won't be able to configure and install the boot loader properly.

### Boot Installer
Now stick your USB drive in and reboot. Your firmware should give you an
option to boot into the NixOS CD which should drop you right into a root
shell from where you can start doing stuff.


Prepare Storage Drive
---------------------
Create an EFI bootable partition and a single GPT partition with an `ext4`
file system.

### Partitioning
Choose the hard drive where you want to install and start `parted` to edit
that device's table, e.g.

    $ lsblk                             # list disks attached to system
    $ parted -a optimal /dev/sda        # edit chosen disk

Note the `-a optimal` option to tell `parted` to choose optimal partition
alignment. In `parted`:
    
    mklabel gpt                         # create GPT partition table,
    
    mkpart ESP fat32 0% 512MiB          # EFI bootable partition,
    set 1 boot on
    name 1 'EFI Sys Part'
    
    mkpart primary ext4 512MiB 100%     # GPT part to host whole OS + data.
    name 2 nixos
    
    q                                   # quit parted

###### Notes
1. *ESP partition size*. Arch Linux [recommends][arch-esp] an EFI System
Partition size of 512MiB.
2. *Partition alignment*. If you get a warning about a partition not being
properly aligned for best performance, the Arch Wiki offers advice on how
to [fix it][arch-parted-alignment].
3. *File system type*. `mkpart` doesn't format the file system, it only
sets a suitable file system code in the partition table.

### Encryption
Here's how to encrypt the whole NixOS and data partition. (Note you should
*not* encrypt the boot partition; it could be done but it's not practical.) 
If you don't need encryption, skip ahead.

    $ cryptsetup luksFormat /dev/sda2
    $ cryptsetup open --type luks /dev/sda2 root

The first line sets up encryption for the partition. The program will first
ask you to confirm the (destructive) command; type an *uppercase* YES or
the program will exit without doing anything. After that, you have to enter
a password that you'll then be prompted for every time the partition needs
unlocking, normally during the boot process. The second line unlocks the
partition so we can format it and mount it later. Note that from now on you
should use `/dev/mapper/root` to refer to this the partition rather than
`/dev/sda2`.

###### Notes
1. *More about DM Crypt*. As usual, the Arch wiki is an excellent [source]
[arch-dm-crypt]!
2. *NixOS Specifics*. The NixOS wiki has an article on how to [encrypt the
root partition][nixos-crypt-root] when using LVM.

### Formatting
Create file systems

    $ mkfs.vfat -F32 /dev/sda1
    $ mkfs.ext4 /dev/sda2         # if you haven't encrypted it

If you've encrypted the disk, then replace the second line above with

    $ mkfs.ext4 /dev/mapper/root

### Mounting
Mount partitions:
 
    $ mount /dev/sda2 /mnt         # if you haven't encrypted it
    $ mkdir -p /mnt/boot
    $ mount /dev/sda1 /mnt/boot

If you've encrypted the disk, then replace the first line above with

    $ mount /dev/mapper/root /mnt


Considerations
--------------

### More on Partitioning
The Arch wiki has lots of good advice on [partitioning][arch-partitioning] 
and is probably worth a read.

### File Systems
For a more flexible (though slightly more complicated) set up you could
use LVM in the second partition above. But bear in mind LVM comes with
some [performance overhead][lvm-performance]. If you want both performance
and flexibility (e.g. disk slicing & dicing, snapshots, etc.), then why
not give Btrfs a try?

### Swap
If you have lots of RAM, you may not need swap space at all. Also consider
that instead of creating an extra swap partition upfront, you can always
add a swap file later when and if you need it.




[arch-dm-crypt]: https://wiki.archlinux.org/index.php/Dm-crypt
    "DM Crypt"
[arch-esp]: https://wiki.archlinux.org/index.php/EFI_System_Partition
    "EFI System Partition"
[arch-parted-alignment]: https://wiki.archlinux.org/index.php/GNU_Parted#Alignment
    "GNU Parted - Alignment"
[arch-partitioning]: https://wiki.archlinux.org/index.php/partitioning
    "Partitioning"
[arch-usb-iso]: https://wiki.archlinux.org/index.php/USB_flash_installation_media#BIOS_and_UEFI_Bootable_USB
    "BIOS and UEFI Bootable USB"
[lvm-performance]: https://www.researchgate.net/publication/284897601_LVM_in_the_Linux_environment_Performance_examination
    "LVM Performance Examination"
[nixos-crypt-root]: https://nixos.org/wiki/Encrypted_Root_on_NixOS
    "Encrypted Root on NixOS"
[nixos-download]: https://nixos.org/nixos/download.html
    "Download NixOS"
[usb-label]: http://askubuntu.com/questions/103686/how-do-i-rename-a-usb-drive/103695#103695
    "How do I rename a USB drive"
[volume-label]: https://en.wikipedia.org/wiki/Volume_(computing)#Volume_label_and_volume_serial_number
    "Volume label and volume serial number"
