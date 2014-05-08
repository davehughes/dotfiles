#!/bin/sh
USER=vagrant
DOTFILES_REPO=git://github.com/davehughes/dotfiles
DOTFILES_DIR=/home/$USER/.dotfiles

sudo apt-get install -y git

if [ ! -d DOTFILES_DIR ]; then
    git clone $DOTFILES_REPO $DOTFILES_DIR
fi

$DOTFILES_DIR/setup.sh

if [ $(which /bin/zsh) ]; then
    sudo chsh -s /bin/zsh $USER
fi
