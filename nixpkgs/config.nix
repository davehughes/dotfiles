{
  channel = "nixpkgs-stable";
  allowUnfree = true;
  overrides = {
    graphite-cli = pkgs.graphite-cli.override { version = "1.38.0"; };  
  };
};
