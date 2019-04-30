# https://wiki.alpinelinux.org/wiki/Classic_install_or_sys_mode_on_Raspberry_Pi

apk update
apk add chrony e2fsprogs

service chronyd restart

mount /dev/sda2 /mnt  # The second partition, in ext4 format, where Alpine Linux is installing in sys mode
setup-disk -m sys /mnt
mount -o remount,rw /media/sda1  # An update in the first partition is required for the next reboot.

rm -f /media/sda1/boot/*  
cd /mnt       # We are in the second partition 
rm boot/boot  # Drop the unused symbolink link

mv boot/* /media/sda1/boot/  
rm -Rf boot
mkdir media/sda1   # It's the mount point for the first partition on the next reboot
ln -s media/sda1/boot boot

echo "/dev/sda1 /media/sda1 vfat defaults 0 0" >> etc/fstab
sed -i '/cdrom/d' etc/fstab   # Of course, you don't have any cdrom or floppy on the Raspberry Pi
sed -i '/floppy/d' etc/fstab
cd /media/sda1

sed -i 's/^/root=\/dev\/sda2 /' /media/sda1/cmdline.txt  

echo "Done -> About to reboot (5 sec)"
sync
wait 5
reboot