#!/bin/bash

# Detect platform-dependent options
OS=`uname -a | cut -d" " -f 1`
echo "OS: $OS"

if [ "$OS" == "Darwin" ]; then
    SCRIPT=`stat -f $0`

    if [ `which brew` ]; then
        PACKAGE_MANAGER=brew
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
elif [ "$OS" == "Linux" ]; then
    SCRIPT=`readlink -f $0`

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
}

function install_apt_packages() {
    echo "Installing aptitude packages..."
    sudo apt-get -y install vim-nox tmux zsh ruby ruby-dev rubygems ssh unzip \
                            exuberant-ctags libjline-java \
                            python-dev python-pip \
                            x11-xserver-utils xdotool
}

function install_yum_packages() {
    echo "Installing yum packages..."
    sudo yum -y install vim tmux zsh ruby ruby-devel rubygems ssh unzip xorg-x11-xkb-utils
}

function install_common_packages() {
    echo "Installing common packages..."
    sudo pip install virtualenv supervisor ipython ipdb
    sudo gem install tmuxinator
}

function install_vundle() {
    if [ ! -d .vim/bundle/vundle ]; then
        mkdir -p .vim/bundle
        git clone git://github.com/gmarik/vundle .vim/bundle/vundle
    else
        pushd .vim/bundle/vundle
        git pull
        popd
    fi
    vim +PluginInstall +qall
}

function symlink_dotfiles() {
    echo "symlinking dotfiles from $SCRIPTDIR to $HOME"
    for f in .* ; do
        [ $f = '.' ] && continue
        [ $f = '..' ] && continue
        [ $f = '.git' ] && continue
        [ $f = '.gitignore' ] && continue
        [ $f = '.ssh' ] && continue
        # ln -sfn $SCRIPTDIR/$f $HOME/$f
        echo "$SCRIPTDIR/$f --> $HOME/$f"
    done

    for f in .ssh/* ; do
        # ln -sfn $SCRIPTDIR/$f $HOME/$f
        echo "$SCRIPTDIR/$f --> $HOME/$f"
    done

    # symlink bin directory
    # ln -sfn $SCRIPTDIR/bin $HOME/bin
    echo "$SCRIPTDIR/bin --> $HOME/bin"
}

# Run main installation
SCRIPTDIR=$(dirname $SCRIPT)
pushd $SCRIPTDIR

echo "running in $SCRIPTDIR"
INSTALL_PACKAGES="install_${PACKAGE_MANAGER}_packages"
eval ${INSTALL_PACKAGES}
install_common_packages
symlink_dotfiles
install_vundle

popd
