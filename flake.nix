{
  description = "My personal monorepo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... }@inputs:
    inputs.utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        inherit (pkgs) callPackage lib;

        glorifiedgluercom = callPackage ./glorifiedgluercom { inherit pkgs; };
        mata = callPackage ./mata { inherit pkgs; };
      in
      lib.recursiveUpdate
        glorifiedgluercom
        mata);
}
