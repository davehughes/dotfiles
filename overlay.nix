# Custom packages live in ./pkgs/<name>/package.nix (same layout as nixpkgs' pkgs/by-name)
final: prev:
let
  local = prev.lib.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./pkgs;
  };
in
# Only fill gaps: when nixpkgs has the package (e.g. tuicr on unstable), use upstream's
prev.lib.filterAttrs (name: _: !(prev ? ${name})) local
