#!/bin/bash -
# vim: set expandtab ts=4 sw=4:

set -o nounset

main() {

    # Create partition
    echo ';' | sfdisk /dev/sda

    # Create fs
    mkfs.ext4 /dev/sda1

    # Mount to default location
    mount /dev/sda1 /mnt
    # Install also development packages
    pacstrap /mnt base base-devel
    genfstab -p /mnt >> /mnt/etc/fstab
    cp chroot.config /mnt
    arch-chroot /mnt /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/anttilinno/archbase/master/tools/chroot.sh)"
    reboot
}

main
