#!/bin/bash

# Detect platform-dependent options
OS=`uname -a | cut -d" " -f 1`
echo "OS: $OS"

if [ "$OS" == "Darwin" ]; then
    SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)

    if [ `which brew` ]; then
        PACKAGE_MANAGER=brew
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
elif [ "$OS" == "Linux" ]; then
    SCRIPT=$(readlink -f $0)
    SCRIPTDIR=$(dirname $SCRIPT)

    if [ `which apt-get` ]; then
        PACKAGE_MANAGER=apt
    elif [ `which yum` ]; then
        PACKAGE_MANAGER=yum
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
else
    echo "Unrecognized OS: $OS" && exit 1
fi
echo "Package manager: $PACKAGE_MANAGER"

function install_brew_packages() {
    echo "Installing OSX packages..."
    brew install ruby
    brew install rubygems
    brew install ruby-build
    brew install ./brew/vim.rb --env=std --with-features=big
    brew install tmux
    brew install zsh
    brew install ctags-exuberant
    brew install fasd
    brew install git-secret
}

function install_apt_packages() {
    echo "Installing aptitude packages..."
    sudo apt-get -y install vim-nox tmux zsh ruby ruby-dev rubygems ssh unzip \
                            exuberant-ctags libjline-java \
                            python-dev python-pip \
                            x11-xserver-utils xdotool \
                            fasd
}

function install_yum_packages() {
    echo "Installing yum packages..."
    sudo yum -y install vim tmux zsh ruby ruby-devel rubygems ssh unzip xorg-x11-xkb-utils fasd
}

function install_common_packages() {
    echo "Installing common packages..."
    sudo pip install virtualenv supervisor ipython ipdb
    sudo gem install tmuxinator
}

function install_vundle() {
    if [ ! -d .vim/bundle/vundle ]; then
        mkdir -p .vim/bundle
        git clone git://github.com/gmarik/vundle vim/.vim/bundle/vundle
    else
        pushd vim/.vim/bundle/vundle >> /dev/null
        git pull
        popd >> /dev/null
    fi
    vim +PluginInstall +qall
}

function stow_core_dotfiles() {
    echo "stowing dotfiles from $SCRIPTDIR to $HOME"
    stow stow
    stow git
    stow postgres
    stow tmux
    stow vagrant
    stow vim
    stow zsh
}

# Run main installation
pushd $SCRIPTDIR >> /dev/null
echo "Dotfiles Path: $SCRIPTDIR"
INSTALL_PACKAGES="install_${PACKAGE_MANAGER}_packages"
eval ${INSTALL_PACKAGES}
install_common_packages
stow_core_dotfiles
install_vundle

popd >> /dev/null
