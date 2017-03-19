System Installation
===================

Partitioning
------------
Make two Mac OS Extended (Journaled) partitions:

1. System partition. Name it `osx` and make it 100 GB wide. This is where to
install OS X and all apps.
2. Data partition. Name it `data` and make it extend from the system partition
to the end of the HD.

The idea here is that the system partition should contain OS X, apps, homes,
and only transient data that should not be backed up. Any data I care about 
should go in the data partition and be backed up. If I need to restore the
system, I could just wipe out the `osx` partition, reinstall OS X on it and
then follow the steps in this installation guide to get the system back as
it was.

OS X Installation
-----------------
Short version:

1. Download OS X from the App Store.
2. Burn a bootable image on a memory stick.
3. Stick it in and reboot, holding `alt` down.
4. At boot prompt, select installation disk, then disk utilities.
5. Partition as above, then go back to menu.
6. Select option to install OS X from menu.

Long version available on the interwebs. Google is your friend.
