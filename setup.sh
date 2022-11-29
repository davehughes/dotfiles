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
    brew install ripgrep
    brew install borkdude/brew/babashka
    brew install borkdude/brew/jet
    brew install koekeishiya/formulae/yabai
    brew install koekeishiya/formulae/skhd
    brew install redis
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
    sudo apt -y install vim-gnome
    sudo apt -y install tmux
    sudo apt -y install zsh
    sudo apt -y install ssh
    sudo apt -y install git
    sudo apt -y install curl
    sudo apt -y install unzip
    sudo apt -y install libjline-java
    sudo apt -y install python-dev
    sudo apt -y install python-pip
    sudo apt -y install python3-dev
    sudo apt -y install python3-pip
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
    sudo apt -y install kitty
    sudo apt -y install xsel
    sudo apt -y install xkbset
    sudo apt -y install tree
    sudo apt -y install ctags
    sudo apt -y install awscli
    sudo apt -y install libpq-dev
    sudo apt -y install mitmproxy
    sudo apt -y install libxml2-dev
    sudo apt -y install libxmlsec1-dev
    sudo apt -y install htop
    sudo apt -y install deluge
    sudo apt -y install chrome-gnome-shell gir1.2-gtop-2.0 gir1.2-networkmanager-1.0  gir1.2-clutter-1.0
    sudo apt -y install gnome-tweak-tool
    sudo apt -y install dnsutils

    install_snap_packages
    install_npm_packages
}

function install_snap_packages() {
    snap install chromium
    snap install slack --classic
    snap install spotify
    snap install wonderwall
    snap connect wonderwall:hardware-observe
    snap install heroku --classic
}

function install_npm_packages() {
    sudo npm install -g qrcode-terminal
}

function install_yum_packages() {
    echo "Installing yum packages..."
    sudo yum update
    sudo yum -y install vim
    sudo yum -y install tmux
    sudo yum -y install zsh
    sudo yum -y install ruby
    sudo yum -y install ruby-devel
    sudo yum -y install rubygems
    sudo yum -y install ssh
    sudo yum -y install unzip
    sudo yum -y install xorg-x11-xkb-utils
    sudo yum -y install fasd
}

function install_common_packages() {
    echo "Installing common packages..."
    sudo -H pip3 install virtualenv
    sudo -H pip3 install ipython
    sudo -H pip3 install ipdb
    sudo -H pip3 install tmuxp
    sudo -H pip3 install awscli
    sudo -H pip3 install docker-compose
    sudo -H pip3 install dbt
    sudo -H pip3 install mitmproxy
}

function install_vundle() {
    if [ ! -d vim/.vim/bundle/vundle ]; then
        mkdir -p vim/.vim/bundle
        git clone https://github.com/gmarik/vundle vim/.vim/bundle/vundle
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
    gvm install go1.19
}

function install_nvm() {
    bash scripts/install-node-nvm.sh
    nvm install node
}

function install_rbenv() {
    RBENV_ROOT=~/.rbenv
    bash scripts/install-rbenv.sh $RBENV_ROOT
    sudo ln -sf $RBENV_ROOT/bin/rbenv ~/bin/rbenv
}

function install_rustup() {
  which rustup || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

function stow_core_dotfiles() {
    echo "stowing dotfiles from $SCRIPTDIR to $HOME"
    stow -R stow
    stow -R clojure
    stow -R git
    stow -R go
    stow -R gpg
    stow -R java
    stow -R kitty
    stow -R node
    stow -R postgres
    stow -R python
    stow -R ruby
    stow -R rust
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
sudo chsh -s $(which zsh) $USER

install_${PACKAGE_MANAGER}_packages
install_common_packages
install_oh_my_zsh
install_gvm
install_nvm
install_rbenv
install_rustup
stow_core_dotfiles
install_vundle
tweak_${PLATFORM}_defaults

popd >> /dev/null
