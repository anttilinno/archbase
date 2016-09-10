#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

mkdir -p /home/antti/.local/bin
mkdir /home/antti/.config

ln -s /home/antti/archbase/config/i3 ~/.config/i3
ln -s /home/antti/archbase/config/localbin ~/.local/bin
ln -s /home/antti/archbase/config/terminator ~/.config/terminator
ln -s /home/antti/archbase/config/xinitrc ~/.xinitrc
ln -s /home/antti/archbase/config/zshrc ~/.zshrc

git clone https://github.com/anttilinno/dotvim /home/antti/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git /home/antti/.config/nvim/bundle/Vundle.vim
