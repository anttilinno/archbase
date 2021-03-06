#!/bin/bash -
# vim: set expandtab ts=4 sw=4:

set -o nounset                              # Treat unset variables as an error

main() {
    # Read config
    . /chroot.config
    # Set machine name
    echo "$GUEST_HOSTNAME" > /etc/hostname
    # Time zone
    rm  -f /etc/localtime
    ln -s /usr/share/zoneinfo/Europe/Tallinn /etc/localtime
    # Add locale
    sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sed -i -e 's/#et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    locale-gen
    mkinitcpio -p linux
    echo "root:$ROOT_PASSWORD" | chpasswd
    pacman -Sy
    pacman -S --noconfirm grub openssh sudo mesa gtkmm zsh xorg-xinit terminator \
        i3 xorg-server git neovim ctags perl-tidy the_silver_searcher \
        python-neovim xsel gmrun diff-so-fancy docker noto-fonts docker-compose \
        pacman-contrib zsh-theme-powerlevel9k dhcpcd

    if [ "$VMTYPE" = "vmware" ]; then
        pacman -S --noconfirm open-vm-tools xf86-video-vmware xf86-input-vmmouse gtkmm3
    else
        pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-modules-arch xf86-video-vmware
    fi

    grub-install --target=i386-pc /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg
    if [ "$VMTYPE" = "vmware" ]; then
        systemctl enable vmtoolsd
        systemctl enable vmware-vmblock-fuse
    else
        systemctl enable vboxservice.service
    fi
    # And change nopasswd after install
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
    useradd -m -G wheel,docker -s /usr/bin/zsh "$OWNER_USER"
    echo "$OWNER_USER:$OWNER_PASSWORD" | chpasswd
    cd /etc/pacman.d

    if [ "$VMTYPE" = "vmware" ]; then
        systemctl enable dhcpcd@ens33.service
    else
        systemctl enable dhcpcd@enp0s3.service
    fi
    systemctl enable docker

    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat <<EOT >> /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${OWNER_USER} --noclear %I \$TERM
EOT

    git clone https://github.com/anttilinno/archbase /home/${OWNER_USER}/.archbase
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/${OWNER_USER}/.oh-my-zsh
    cd /home/${OWNER_USER}/.archbase/tools
    ./create_links.sh "/home/${OWNER_USER}"
    # Create Repo directory
    mkdir -p /home/${OWNER_USER}/Repo/Begin
    mkdir /home/${OWNER_USER}/.ssh
    cp /home/${OWNER_USER}/.archbase/config/config.data /home/${OWNER_USER}/.ssh/
    chmod 0700 /home/${OWNER_USER}/.ssh
    touch /home/${OWNER_USER}/.ssh/id_rsa
    chmod 0600 /home/${OWNER_USER}/.ssh/id_rsa

    if [ "$VMTYPE" = "vmware" ]; then
        sed -i '1s/^#//' /home/${OWNER_USER}/.xinitrc
        cat <<vmwareFix >> /home/${OWNER_USER}/.ssh/config
Host *
    IPQoS=throughput
vmwareFix

    else
        sed -i '2s/^#//' /home/${OWNER_USER}/.xinitrc
    fi

    chown -R ${OWNER_USER}:${OWNER_USER} /home/${OWNER_USER}

    exit
}

main
