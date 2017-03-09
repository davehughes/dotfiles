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
    brew install stow
    brew install ruby
    brew install ruby-build
    brew install ./brew/vim.rb --env=std --with-features=big
    brew install tmux
    brew install zsh
    brew install ctags-exuberant
    brew install fasd
    brew install git-secret
    brew install neovim/neovim/neovim
    pip install neovim  # required for python support
    brew install rlwrap
    brew install outh-toolkit
    brew install pwgen
    brew install the_silver_searcher
    brew install Caskroom/cask/karabiner-elements
    brew install Caskroom/cask/seil 
    brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste
}

function tweak_defaults() {
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool TRUE
    defaults write -g InitialKeyRepeat 12
    defaults write -g KeyRepeat 1
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
    if [ ! -d vim/.vim/bundle/vundle ]; then
        mkdir -p vim/.vim/bundle
        git clone git://github.com/gmarik/vundle vim/.vim/bundle/vundle
    else
        pushd vim/.vim/bundle/vundle >> /dev/null
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

function install_gvm() {
    sh scripts/install-gvm.sh
    ln -s ~/.gvm/bin/gvm /usr/local/bin/gvm
    ln -s ~/.gvm/bin/gvmsudo /usr/local/bin/gvmsudo
    ln -s ~/.gvm/bin/gvm-prompt /usr/local/bin/gvm-promp
    gvm install go1.4 -B
    gvm install go1.7.2 -B
    gvm install go1.8 -B
}

function stow_core_dotfiles() {
    echo "stowing dotfiles from $SCRIPTDIR to $HOME"
    stow -R stow
    stow -R git
    stow -R postgres
    stow -R tmux
    stow -R vagrant
    stow -R vim
    stow -R zsh
}

# Run main installation
pushd $SCRIPTDIR >> /dev/null
echo "Dotfiles Path: $SCRIPTDIR"
INSTALL_PACKAGES="install_${PACKAGE_MANAGER}_packages"
eval ${INSTALL_PACKAGES}
install_common_packages
install_oh_my_zsh
install_gvm
stow_core_dotfiles
install_vundle
tweak_defaults

popd >> /dev/null
