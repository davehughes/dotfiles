# I've encountered [this issue](https://github.com/NixOS/nix/issues/3616), which seems to be related to OSX upgrades
# removing these from PATH, so I'm just going to add them here manually
add_to_PATH /nix/var/nix/profiles/default/bin
add_to_PATH $HOME/.nix-profile/bin
