{
  description = "My personal monorepo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) callPackage lib;

        glorifiedgluercom = callPackage ./glorifiedgluercom { inherit pkgs utils; };
        mata = callPackage ./mata { inherit pkgs utils; };
      in
      lib.recursiveUpdate
        glorifiedgluercom
        mata);
}
