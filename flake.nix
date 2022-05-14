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

        projects = builtins.map (value: callPackage value { inherit pkgs utils; }) [
          ./glorifiedgluercom
          ./mata
        ];
      in
      lib.foldr (atrrset: acc: lib.recursiveUpdate atrrset acc)
        { }
        projects);
}
