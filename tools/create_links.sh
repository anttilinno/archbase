#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

mkdir -p /home/antti/.local/bin
mkdir /home/antti/.config

ln -s /home/antti/archbase/config/i3 /home/antti/.config/i3
ln -s /home/antti/archbase/config/localbin /home/antti/.local/bin
ln -s /home/antti/archbase/config/terminator /home/antti/.config/terminator
ln -s /home/antti/archbase/config/xinitrc /home/antti/.xinitrc
ln -s /home/antti/archbase/config/zshrc /home/antti/.zshrc

git clone https://github.com/anttilinno/dotvim /home/antti/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git /home/antti/.config/nvim/bundle/Vundle.vim
