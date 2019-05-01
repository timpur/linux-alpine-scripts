# https://wiki.alpinelinux.org/wiki/Classic_install_or_sys_mode_on_Raspberry_Pi

if [ -z "$1"]
then 
    echo "Please provide a boot partition (eg sda1)"
fi

if [ -z "$2"]
then 
    echo "Please provide a os partition (eg sda2)"
fi

$boot=$1
$os=$2

apk update
apk add chrony e2fsprogs

service chronyd restart

mount "/dev/$os" "/mnt"  # The second partition, in ext4 format, where Alpine Linux is installing in sys mode
setup-disk -m sys /mnt
mount -o remount,rw "/media/$boot"  # An update in the first partition is required for the next reboot.

rm -f "/media/$boot/boot/*"  
cd /mnt       # We are in the second partition 
rm boot/boot  # Drop the unused symbolink link

mv boot/* "/media/$boot/boot/" 
rm -Rf boot
mkdir "media/$boot"   # It's the mount point for the first partition on the next reboot
ln -s "media/$boot/boot" boot

echo "/dev/$boot /media/$boot vfat defaults 0 0" >> etc/fstab
sed -i '/cdrom/d' etc/fstab   # Of course, you don't have any cdrom or floppy on the Raspberry Pi
sed -i '/floppy/d' etc/fstab
cd "/media/$boot"

sed -i "s/^/root=\/dev\/$os /" "/media/$boot/cmdline.txt"  

echo "Done -> About to reboot (5 sec)"
sync
sleep 5
reboot