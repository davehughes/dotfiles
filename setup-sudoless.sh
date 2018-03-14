#!/bin/bash

# Detect platform-dependent options
OS=`uname -a | cut -d" " -f 1`
echo "OS: $OS"

if [ "$OS" == "Darwin" ]; then
	echo "If you're running OSX and can't get root, I can't help you..." && exit 1
fi

if [ "$OS" == "Linux" ]; then
    PLATFORM=linux
    SCRIPT=$(readlink -f $0)
    SCRIPTDIR=$(dirname $SCRIPT)
else
    echo "Unrecognized OS: $OS" && exit 1
fi
echo "Platform: $PLATFORM"

# TODO: Check for packages and complain if they're not found
# which vim
# which tmux
# which zsh
# which ag
# which python

# Create basic directory structure in home
mkdir -p ~/bin
mkdir -p ~/.zsh

function install_vundle() {
	VUNDLE_ROOT=~/.vim/bundle/vundle
    if [ ! -d $VUNDLE_ROOT ]; then
        mkdir -p $(dirname $VUNDLE_ROOT)
        git clone git://github.com/gmarik/vundle $VUNDLE_ROOT
    else
        pushd $VUNDLE_ROOT >> /dev/null
        git pull
        popd >> /dev/null
    fi
    vim +PluginInstall +qall
}

function install_oh_my_zsh() {
    rm -rf ~/.oh-my-zsh
    sh scripts/install-oh-my-zsh.sh
    rm -rf ~/.oh-my-zsh/custom
}

function stow_core_dotfiles() {
    # Since we can't count on stow existing, we can do this manually :-/
    ln -sf $SCRIPTDIR/vim/.vimrc ~/.vimrc
    ln -sf $SCRIPTDIR/vim/.vim ~/.vim
    ln -sf $SCRIPTDIR/tmux/.tmux.conf ~/.tmux.conf
    ln -sf $SCRIPTDIR/tmux/.zsh/tmux.zsh ~/.zsh/tmux.zsh
    ln -sf $SCRIPTDIR/util/bin/fasd ~/bin/fasd
    ln -sf $SCRIPTDIR/zsh/.oh-my-zsh ~/.oh-my-zsh
    ln -sf $SCRIPTDIR/zsh/.oh-my.zsh ~/.oh-my.zsh
    ln -sf $SCRIPTDIR/zsh/.oh-my-zsh/custom ~/.oh-my-zsh/custom
    ln -sf $SCRIPTDIR/zsh/.zshenv ~/.zshenv
    ln -sf $SCRIPTDIR/zsh/.zshrc ~/.zshrc
    ln -sf $SCRIPTDIR/zsh/.zsh/aliases.zsh ~/.zsh/aliases.zsh
}

# Run main installation
pushd $SCRIPTDIR >> /dev/null
echo "Dotfiles Path: $SCRIPTDIR"

# Set shell
# chsh -s $(which zsh) $USER
install_oh_my_zsh
stow_core_dotfiles
install_vundle

popd >> /dev/null
