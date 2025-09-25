{
  channel = "nixpkgs-stable";
  allowUnfree = true;
  overrides = {
    graphite-cli = pkgs.graphite-cli.override { version = "1.38.0"; };  
  };
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
};
