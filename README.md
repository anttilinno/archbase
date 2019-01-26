# How things are done
Meenutab natuke raamatu sisu [Kuidas meil asjad käivad](https://www.goodreads.com/book/show/18078693-kuidas-meil-asjad-k-ivad)

First steps:

 - `pacman -Sy && pacman -S git`
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
 - `nvm install 8.15.0 && npm install yarn -g`

### Git configuration
There is already a default git configuration.
In case it needs to be recreated:

 - `git config --global init.templatedir '~/.git-templates'`
 - Re-initialize git in each existing repo you'd like to use this in: `git init`. **NOTE** if you already have a hook defined in your local git repo, this will not overwrite it.


### Unpack ssh config
  - `gpg --output config --decrypt config.data && rm config.data`
  - Populate id_rsa with real key

### VMWare bonus

`Edit>Preferences>Shared VMs>Change Settings>Disable Sharing`
This will free up 443 port or one can change the port to something else
`Edit>Virtual Network Editor>Change Settings>NAT>NAT Settings`
Add port forward for 80 and 443 from guest to host.

### Other steps to do

  - Install yay
  - Install nerd fonts https://github.com/ryanoasis/nerd-fonts#font-installation
    with `yay -S nerd-fonts-complete`
  - Install catacomb

### Crypt files with gpg
  - `gpg --output doc.gpg --symmetric doc`
