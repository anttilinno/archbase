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
    arch-chroot /mnt /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/anttilinno/archbase/master/tools/chroot.sh)"
}

main
