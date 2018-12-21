# How things are done
Meenutab natuke raamatu sisu [Kuidas meil asjad käivad](https://www.goodreads.com/book/show/18078693-kuidas-meil-asjad-k-ivad)

First steps:

 - `pacman -Sy && pacman -S git pacman-contrib`
 - `git clone https://github.com/anttilinno/archbase.git`
 - `cd archbase/tools`
 - `cp chroot.config.example chroot.config`
 - Modify values to match your taste `vim chroot.config`
 - `./install.sh`

## First login

 - `cd Repo/Begin && git clone git@bitbucket.org:begin/begin_docker.git docker`
 - `unset NVM_DIR`
 - `cd && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash`
 - `source .zshrc`
 - `nvm install 8.14.0 && npm install yarn -g`

## Docker bug with 4.19 kernels

- edit /etc/default/grub and modify line that says:
`GRUB_CMDLINE_LINUX_DEFAULT="quiet"` to `GRUB_CMDLINE_LINUX_DEFAULT="quiet overlay.metacopy=N"`
- Install new grub
`grub-mkconfig -o /boot/grub/grub.cfg && grub-install --target=i386-pc /dev/sda`

### Git configuration
There is already a default git configuration.
In case it needs to be recreated:

 - `git config --global init.templatedir '~/.git-templates'`
 - Re-initialize git in each existing repo you'd like to use this in: `git init`. **NOTE** if you already have a hook defined in your local git repo, this will not overwrite it.

