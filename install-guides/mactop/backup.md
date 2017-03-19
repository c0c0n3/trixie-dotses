Backups
=======

The system partition (`osx`) should only contain OS X, apps, homes, and 
transient data. So I'm **not** backing up `osx`. On the other hand, I've 
got stuff I care about in the `data` partition, but only some directories
need a backup. In fact, `github` only has local copies of GitHub repos in
it, whereas `VMs` contains virtual machines that I can easily recreate from
scratch; so it's pointless to back up these two directories. All the other
top-level directories should get backed up to my Google drives.

To do that, I've put together some simple scripts and config that use 
[Rclone][rclone] to do the heavy lifting, all documented [over here]
[backup-scripts].




[backup-scripts]: https://github.com/c0c0n3/hAppYard/tree/master/cocone-backup
    "Backup Scripts"
[rclone]: http://rclone.org/
    "Rclone Home"
