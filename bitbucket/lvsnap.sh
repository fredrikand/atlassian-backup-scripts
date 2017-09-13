## lock Bitbucket
lvcreate -L2G -s -n backup /dev/lvm-test/lvol0
pg_dump ...

mount /dev/lvm-test/backup /mnt/backup/ -onouuid,ro
## Do the copy stuff from disk
umount /mnt/backup 
lvremove /dev/lvm-test/backup 
lvremove -y /dev/lvm-test/backup

