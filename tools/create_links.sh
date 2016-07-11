#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

mkdir -p ~/.local/bin
mkdir ~/.config

ln ../config/i3 ~/.config/i3
ln ../config/localbin ~/.local/bin
ln ../config/terminator ~/.config/terminator
ln ../config/xinitrc ~/.xinitrc
ln ../config/zshrc ~/.zshrc

git clone https://github.com/anttilinno/dotvim ~/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
