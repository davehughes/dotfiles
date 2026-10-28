{
  description = "Home Manager configuration of dave";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixpkgs 26.11 dropped x86_64-darwin; 26.05 gets security fixes until end of 2026
    nixpkgs-intel.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    home-manager-intel = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-intel";
    };
  };

  outputs = { nixpkgs, home-manager, nixpkgs-intel, home-manager-intel, ... }:
    let
      mkHome = nixpkgs: home-manager: system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    in {
      # home-manager prefers "user@hostname" over "user" when both exist
      homeConfigurations."dave" = mkHome nixpkgs home-manager "aarch64-darwin";
      # Intel MacBook Pro
      homeConfigurations."dave@dsh-mbp" = mkHome nixpkgs-intel home-manager-intel "x86_64-darwin";

      # Custom packages from ./pkgs, exposed so `nix-update --flake <name>` can bump them
      packages = builtins.mapAttrs
        (system: nixpkgs: let pkgs = nixpkgs.legacyPackages.${system}; in import ./overlay.nix pkgs pkgs)
        { aarch64-darwin = nixpkgs; x86_64-darwin = nixpkgs-intel; };
    };
}
