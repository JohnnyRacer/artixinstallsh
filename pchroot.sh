#!/bin/bash

echo "Enter the Region"
read -r regiona
echo "Enter the City"
read -r citya

echo "Enter the Region"
read -r regiona
echo "Enter the City"
read -r citya

ln -sf /usr/share/zoneinfo/"$regiona"/"$citya" /etc/localtime && echo "Region Set OK";
hwclock --systohc && pacman -Sy linux-zen linux-firmware nano glibc make git wpa_supplicant dhcpcd grub efibootmgr os-prober connman-openrc connman-gtk && rc-update add connmand && echo "Time set, preliminary utils installed";
nano /etc/locale.gen; locale-gen && export LANG="en_US.UTF-8" ; export LC_COLLATE="C";
mkinitcpio -P && grub-mkconfig -o /boot/grub/grub.cfg &&
echo "Type Your Password (Root Acc)";
passwd &&
echo "Type your user name"
read -r umonk
useradd -m -g users "$umonk" &&
echo "Type password";
passwd "$umonk" && echo "Installation Compelete...Exiting Chroot";
exit


