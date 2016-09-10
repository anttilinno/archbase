#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

mkdir -p ~/.local/bin
mkdir ~/.config

ln -s ../config/i3 ~/.config/i3
ln -s ../config/localbin ~/.local/bin
ln -s ../config/terminator ~/.config/terminator
ln -s ../config/xinitrc ~/.xinitrc
ln -s ../config/zshrc ~/.zshrc

git clone https://github.com/anttilinno/dotvim ~/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
