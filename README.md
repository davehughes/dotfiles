My stock dev tools and settings loadout, organized via home-manager. Use as you see fit.

Installation:
-------------
```sh
# if nix/home manager aren't installed:
sh <(curl -L https://nixos.org/nix/install)
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-shell '<home-manager>' -A install

git clone https://github.com/davehughes/dotfiles ~/.config/home-manager
home-manager switch
```

Layers:
-------
+ desktop -> [skhd](https://github.com/koekeishiya/skhd) + [yabai](https://github.com/koekeishiya/yabai)
+ terminal -> [kitty](https://sw.kovidgoyal.net/kitty/)
+ [tmux](https://github.com/tmux/tmux/wiki) + [nord theme](https://www.nordtheme.com/ports/tmux)
+ shell -> zsh + [Starship](https://starship.rs)-based prompt theme
+ shell utilities
  + [dave-cli](https://github.com/davehughes/dave-cli)
+ editor (nvim)


Updating:
---------
```
nix flake update
hm switch
```

Recovering:
-----------
Because OSX is horrendous dogshit, system upgrades love to overwrite essential sections of the system
default rc files, including the bits that we need for home-manager to work. (Re)add the following lines
to restore:
```
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```
