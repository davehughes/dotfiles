My stock dev tools and settings loadout, organized via home-manager. Use as you see fit.

Installation (Standard):
------------------------
```sh
git clone https://github.com/davehughes/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

Layers:
-------

+ Desktop
  + applications (TODO: how to store/pull images for common software?)
    + some leads:
      https://www.reddit.com/r/NixOS/comments/112feik/issues_with_installing_applications_on_macos/j8k5upo/
      https://github.com/dustinlyons/nixos-config/blob/main/darwin/home-manager.nix#L31
+ tmux
+ shell (zsh)
+ shell utilities
  + custom plugins via zplug
  + custom python CLI as Swiss Army knife of functionality across these layers
+ editor (vim)
