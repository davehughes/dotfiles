#!/bin/sh

# Detect package manager and use it to install dependencies
OS=`uname -a | cut -d" " -f 1`
if [ $OS == 'Darwin' ]
then
    if [ `which brew` ]; then
        PACKAGE_MANAGER=brew
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
elif [ $OS -eq 'Linux' ]; then
    if [ `which apt` ]; then
        PACKAGE_MANAGER=apt
    elif [ `which yum` ]; then
        PACKAGE_MANAGER=yum
    else
        echo 'No package manager found.  Install aptitude or yum to continue.' && exit 1
    fi
else
    echo "Unrecognized OS: $OS" && exit 1
fi


DEPS_SCRIPT="deps.${PACKAGE_MANAGER}.sh"
echo "Installing dependencies with $PACKAGE_MANAGER"
$DEPS_SCRIPT

# Install common dependencies
pip install flake8
sudo gem install tmuxinator
