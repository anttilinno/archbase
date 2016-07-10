#!/bin/bash -
# vim: set expandtab ts=4 sw=4:

set -o nounset

main() {

    # Create partition
    sfdisk /dev/sda <<DiskLayOut
label: dos
label-id: 0x3eb3bc30
device: /dev/sda
unit: sectors

/dev/sda1 : start=        2048, size=    16775168, type=83, bootable
DiskLayOut

    # Create fs
    mkfs.ext4 /dev/sda1

    # Mount to default location
    mount /dev/sda1 /mnt
    # Install also development packages
    pacstrap /mnt base base-devel
    genfstab -p /mnt >> /mnt/etc/fstab
    arch-chroot /mnt /bin/bash
    # Set machine name
    echo manhattan > /etc/hostname
    # Time zone
    ln -s /usr/share/zoneinfo/Europe/Tallinn /etc/localtime
    # Add locale
    sed -i -e 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sed -i -e 's/# *et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    locale-gen
    mkinitcpio -p linux
    passwd
    pacman -S syslinux openssh sudo open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa gtkmm zsh
    sed 's:/dev/sda3:/dev/sda1:g' /boot/syslinux/syslinux.cfg
    syslinux-install_update -i -a -m
    systemctl enable sshd
    systemctl enable vmtoolsd
    systemctl enable vmware-vmblock-fuse
    sed -i -e 's:#includedir /etc/sudoers.d:includedir /etc/sudoers.d' /etc/sudoers
    visudo -c -q -f - <<SuDoersTest
%wheel ALL=(ALL) NOPASSWD: ALL
SuDoersTest
    # And change nopasswd after install
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
    useradd -m -G wheel ansible
    passwd ansible
    reboot
}

main
