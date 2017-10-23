#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

BASE_DIR="$1"

mkdir -p ${BASE_DIR}/.local/bin
mkdir ${BASE_DIR}/.config

ln -s ${BASE_DIR}/.archbase/config/i3 ${BASE_DIR}/.config/i3
ln -s ${BASE_DIR}/.archbase/config/localbin ${BASE_DIR}/.local/bin
ln -s ${BASE_DIR}/.archbase/config/xinitrc ${BASE_DIR}/.xinitrc
ln -s ${BASE_DIR}/.archbase/config/zshrc ${BASE_DIR}/.zshrc

git clone https://github.com/anttilinno/dotvim ${BASE_DIR}/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git ${BASE_DIR}/.config/nvim/bundle/Vundle.vim

ln -s /usr/bin/nvim /usr/local/bin/vim

