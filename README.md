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
