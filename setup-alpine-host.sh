# Add sudo and nano apks
apk add sudo nano

# Add user admin
adduser admin

# Add admin user to sudoers
sed -i "\$s/$/\nadmin ALL=(ALL) ALL\n/" /etc/sudoers

# Add admin user to allow ssh
sed -i "s/wheel:x:10:root/wheel:x:10:root,admin" /etc/group

# Uncomment comunity repositry
sed -i "/v\d\.\d\/comunity/s/^#//" /etc/apk/repositories

# Update and Upgrade
apk update
apk upgrade

# Add docker
apk add docker
rc-update add docker boot 
service docker start 
mkdir /docker

# Add Hyper-V tools
VM=$(dmesg | grep "Hypervisor detected")
if [ $VM == *"Microsoft Hyper-V"* ]
then
    apk add hvtools
    rc-update add hv_fcopy_daemon
    rc-update add hv_kvp_daemon
    rc-update add hv_vss_daemon
fi

# Reboot
reboot
