#!/bin/bash

# Detect platform-dependent options
OS=`uname -a | cut -d" " -f 1`
echo "OS: $OS"

if [ "$OS" == "Darwin" ]; then
    PLATFORM=osx
    SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)

    if [ `which brew` ]; then
        PACKAGE_MANAGER=brew
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
elif [ "$OS" == "Linux" ]; then
    PLATFORM=linux
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
echo "Platform: $PLATFORM"
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
    brew install git-secret
    brew install rlwrap
    brew install outh-toolkit
    brew install pwgen
    brew install the_silver_searcher
    brew install Caskroom/cask/karabiner-elements
    brew install Caskroom/cask/seil 
    brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste
    brew install jq
}

function tweak_osx_defaults() {
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool TRUE
    defaults write com.apple.finder AppleShowAllFiles -bool TRUE
    defaults write -g InitialKeyRepeat 10
    defaults write -g KeyRepeat 1
}

function tweak_linux_defaults() {
    dconf write /org/gnome/gnome-session/auto-save-session true
}

function install_apt_packages() {
    echo "Installing aptitude packages..."
    # Update
    sudo apt update

    # Install dependencies
    sudo apt -y install stow
    sudo apt -y install tmux
    sudo apt -y install zsh
    sudo apt -y install ssh
    sudo apt -y install git
    sudo apt -y install unzip
    sudo apt -y install libjline-java
    sudo apt -y install python-dev
    sudo apt -y install python-pip
    sudo apt -y install x11-xserver-utils
    sudo apt -y install xdotool
    sudo apt -y install silversearcher-ag
    sudo apt -y install oathtool
    sudo apt -y install pwgen
    sudo apt -y install openjdk-8-jre-headless
    sudo apt -y install racket
    sudo apt -y install mit-scheme
    sudo apt -y install r-base
    sudo apt -y install jq
    sudo apt -y install rlwrap
    sudo apt -y install compizconfig-settings-manager
    sudo apt -y install dconf-editor
    sudo apt -y install bison  # required for gvm
    sudo apt -y install redshift
}

function install_yum_packages() {
    echo "Installing yum packages..."
    sudo yum -y install vim tmux zsh ruby ruby-devel rubygems ssh unzip xorg-x11-xkb-utils fasd
}

function install_common_packages() {
    echo "Installing common packages..."
    sudo pip install virtualenv supervisor ipython ipdb tmuxp
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
    bash scripts/install-gvm.sh
    sudo ln -sf ~/.gvm/bin/gvm /usr/local/bin/gvm
    sudo ln -sf ~/.gvm/bin/gvmsudo /usr/local/bin/gvmsudo
    sudo ln -sf ~/.gvm/bin/gvm-prompt /usr/local/bin/gvm-prompt
    gvm install go1.12 -B
}

function install_rbenv() {
    RBENV_ROOT=~/.rbenv
    bash scripts/install-rbenv.sh $RBENV_ROOT
    sudo ln -sf $RBENV_ROOT/bin/rbenv ~/bin/rbenv
}

function stow_core_dotfiles() {
    echo "stowing dotfiles from $SCRIPTDIR to $HOME"
    stow -R stow
    stow -R git
    stow -R postgres
    stow -R python
    stow -R go
    stow -R rust
    stow -R ruby
    stow -R tmux
    stow -R vagrant
    stow -R vim
    stow -R util
    stow -R zsh
    stow -R --target $HOME --dir platforms $PLATFORM
}

# Run main installation
pushd $SCRIPTDIR >> /dev/null
echo "Dotfiles Path: $SCRIPTDIR"

# Set shell
chsh -s $(which zsh) $USER

install_${PACKAGE_MANAGER}_packages
install_common_packages
install_oh_my_zsh
install_gvm
install_rbenv
stow_core_dotfiles
install_vundle
tweak_${PLATFORM}_defaults

popd >> /dev/null
