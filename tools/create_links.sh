#!/bin/bash -

set -o nounset                              # Treat unset variables as an error

BASE_DIR="$1"

mkdir -p ${BASE_DIR}/.local
mkdir ${BASE_DIR}/.config

ln -s ${BASE_DIR}/.archbase/config/i3 ${BASE_DIR}/.config/i3
ln -s ${BASE_DIR}/.archbase/config/localbin ${BASE_DIR}/.local/bin
ln -s ${BASE_DIR}/.archbase/config/terminator ${BASE_DIR}/.config/terminator
ln -s ${BASE_DIR}/.archbase/config/xinitrc ${BASE_DIR}/.xinitrc
ln -s ${BASE_DIR}/.archbase/config/zshrc ${BASE_DIR}/.zshrc
ln -s ${BASE_DIR}/.archbase/config/zprofile ${BASE_DIR}/.zprofile
ln -s ${BASE_DIR}/.archbase/config/gotorc ${BASE_DIR}/.goto
ln -s ${BASE_DIR}/.archbase/config/gitconfig ${BASE_DIR}/.gitconfig
ln -s ${BASE_DIR}/.archbase/config/pgpass ${BASE_DIR}/.pgpass
ln -s ${BASE_DIR}/.archbase/config/catacomb ${BASE_DIR}/.catacomb

git clone https://github.com/anttilinno/dotvim ${BASE_DIR}/.config/nvim
git clone https://github.com/VundleVim/Vundle.vim.git ${BASE_DIR}/.config/nvim/bundle/Vundle.vim

ln -s /usr/bin/nvim /usr/local/bin/vim

