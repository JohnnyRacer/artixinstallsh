#! /bin/bash
# Scripted By Johnnyracer 
# Artix Install Script Initial Base Setup
# 2021 


dhcpcd

ping gnu.org -c 3


echo  "Please enter the /mnt/boot disk (ex. sda1, nvmeblk0p1, etc.)"
read -r bootdi

echo  "Please enter the /mnt/home disk (ex. sda2, nvmeblk0p2, etc."
read -r homedi

echo  "Please enter the /mnt disk (ex. sda3, nvmeblk0p3, etc.)"
read -r rootdi

echo  "Please enter the /swap disk (ex. sda4, nvmeblk0p4, etc.)"
read -r swapdi


arrVar=("$bootdi" "$homedi" "$rootdi" "$swapdi")


# Iterate the loop to read and print each array element



# df /dev/"$value" | grep -oP "$value.* \K\d+(?=\s+\d+%)" grep filter
# Iterate the loop to read and print each array element
for value in "${arrVar[@]}"
do
    msize=${#value} 
    echo "$msize" 
    if (($msize > 3)) && udevadm info -a -p  eval udevadm info -q path -n /dev/"$value" &> /dev/null; then
    
    echo "Disk selection Okay"
    
    else

    echo "Not Okay, check disk selection"
    
    break
    fi

    
done


mkdir /mnt/boot && mkfs.vfat /dev/"$bootdi" && mount /dev/"$bootdi" /mnt/boot && echo "Mounted /boot Sucessfully";
mkfs.ext4 /dev/"$rootdi" && mount /dev/"$rootdi" /mnt && echo "Listing /mnt & /mnt/boot rn"; ls /mnt && ls /mnt/boot && echo "Seems Good, Can you see the ls?";



qsize=${#$(eval df /dev/"$swapdi"&& echo "okay")}
psize=${#$(eval df /dev/"$swapdi"&& echo "okay")}



if (($psize != 0 )); then

eval fdisk /dev/"$swapdi" -l
echo "Swap works okay!"
mkswap /dev/"$swapdi" && swapon /dev/"$swapdi" && echo "Mounted swap & turned on Sucessfully";

else 

echo "Invalid Disk Try Again"
return
fi


if (($qsize != 0 )); then

eval fdisk /dev/"$homedi" -l
echo "Home works okay!"
mkdir /mnt/home && mkfs.ext4 /dev/"$homedi" && mount /dev/"$homedi" && echo "Mounted /home Sucessfully";

else 

echo "Invalid Disk Try Again"
return
fi


basestrap /mnt base base-devel openrc elogind-openrc &&

basestrap /mnt linux-zen linux-firmware &&

pacman -S nano glibc links git &&

fstabgen -U /mnt >> /mnt/etc/fstab &&

mkdir artix_pchroot &&

cp pchroot.sh /mnt/artix_pchroot ;

echo "Base system setup looks okay....Ready to chroot to /mnt (Any key to continue)";
read chstr
chrans=${#chstr} 

if (($chrans != 0)); then

artix-chroot /mnt


else

echo "Quitting"

fi


