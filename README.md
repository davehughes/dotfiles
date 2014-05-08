My vim settings and plugins. Use as you see fit.

Installation (Standard):
------------------------
```sh
git clone https://github.com/davehughes/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

Installation (Vagrant):
-----------------------
The vagrant box in `vagrant/debian` can run as-is or used as a template for customized boxes.  The provisioning step checks out this repository and installs the dotfiles as described in the host installation section above.  All you should need to run is:
```sh
vagrant up
vagrant ssh
```
