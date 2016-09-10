#!/bin/bash -
# vim: set expandtab ts=4 sw=4:

set -o nounset                              # Treat unset variables as an error

main() {
    # Read config
    . /chroot.config
    # Set machine name
    echo "$GUEST_HOSTNAME" > /etc/hostname
    # Time zone
    ln -s /usr/share/zoneinfo/Europe/Tallinn /etc/localtime
    # Add locale
    sed -i -e 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sed -i -e 's/# *et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    locale-gen
    mkinitcpio -p linux
    echo "root:$ROOT_PASSWORD" | chpasswd
    pacman -S --noconfirm grub openssh sudo open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa gtkmm zsh xorg-xinit terminator i3 xorg-server ttf-hack git neovim ctags perl-tidy the_silver_searcher python2-neovim xsel
    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    systemctl enable sshd
    systemctl enable vmtoolsd
    systemctl enable vmware-vmblock-fuse
    sed -i -e 's:#includedir /etc/sudoers.d:includedir /etc/sudoers.d:' /etc/sudoers
    visudo -c -q -f - <<SuDoersTest
%wheel ALL=(ALL) NOPASSWD: ALL
SuDoersTest
    # And change nopasswd after install
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
    useradd -m -G wheel "$GUEST_USER"
    echo "$GUEST_USER:$GUEST_PASSWORD" | chpasswd
    useradd -m -G wheel -s /usr/bin/zsh antti
    cd /etc/pacman.d
    cp mirrorlist mirrorlist.backup
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
    rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
    systemctl enable dhcpcd@ens33.service
    cat <<'EOT' >> /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOT
    pacman -Sy
    pacman -S --noconfirm yaourt
    su - antti
    git clone https://github.com/anttilinno/archbase
    exit
}

main
