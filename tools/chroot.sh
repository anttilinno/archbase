#!/bin/bash -
# vim: set expandtab ts=4 sw=4:

set -o nounset                              # Treat unset variables as an error

main() {
    # Read config
    . /chroot.config
    # Set machine name
    echo "$GUEST_HOSTNAME" > /etc/hostname
    # Time zone
    rm /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Tallinn /etc/localtime
    # Add locale
    sed -i -e 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sed -i -e 's/# *et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    locale-gen
    mkinitcpio -p linux
    echo "root:$ROOT_PASSWORD" | chpasswd
    pacman -Sy
    pacman -S --noconfirm grub openssh sudo mesa zsh xorg-xinit i3 xorg-server ttf-hack git neovim ctags perl-tidy the_silver_searcher python2-neovim xsel gmrun diff-so-fancy

    if [ "$VMTYPE" = "vmware" ]; then
        pacman -S --noconfirm open-vm-tools xf86-video-vmware xf86-input-vmmouse
    else
        pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-modules-arch
    fi

    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    if [ "$VMTYPE" = "vmware" ]; then
        systemctl enable vmtoolsd
        systemctl enable vmware-vmblock-fuse
    else
        systemctl enable vboxservice.service
    fi
    visudo -c -q -f - <<SuDoersTest
%wheel ALL=(ALL) NOPASSWD: ALL
SuDoersTest
    # And change nopasswd after install
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
    useradd -m -G wheel -s /usr/bin/zsh "$OWNER_USER"
    echo "$OWNER_USER:$OWNER_PASSWORD" | chpasswd
    cd /etc/pacman.d
    cp mirrorlist mirrorlist.backup
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
    rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

    if [ "$VMTYPE" = "vmware" ]; then
        systemctl enable dhcpcd@ens33.service
    else
        systemctl enable dhcpcd@enp0s3.service
    fi

    cat <<'EOT' >> /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOT
    pacman -Sy
    pacman -S --noconfirm yaourt
    yaourt -S --noconfirm tilix-bin
    git clone https://github.com/anttilinno/archbase /home/${OWNER_USER}/.archbase
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/${OWNER_USER}/.oh-my-zsh
    cd /home/${OWNER_USER}/.archbase/tools
    ./create_links.sh "/home/${OWNER_USER}"
    chown -R ${OWNER_USER}:${OWNER_USER} /home/${OWNER_USER}

    if [ "$VMTYPE" = "vmware" ]; then
        sed -i '1s/^#//' /home/${OWNER_USER}/.xinitrc
    else
        sed -i '2s/^#//' /home/${OWNER_USER}/.xinitrc
    fi

    exit
}

main
