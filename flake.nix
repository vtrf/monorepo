{
  description = "My personal monorepo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:NixOS/nixos-hardware";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";
    homeManager.url = "github:nix-community/home-manager";
    nixColors.url = "github:misterio77/nix-colors";
    nixDoomEmacs.url = "github:nix-community/nix-doom-emacs";
    nixDoomEmacs.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/nur";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (inputs) nixpkgs;
      inherit (nixpkgs) lib;
      projects = builtins.map (project: import project { inherit inputs; }) [
        ./dotfiles
        ./glorifiedgluercom
        ./mata
      ];
    in
    lib.foldr (attrset: acc: lib.recursiveUpdate attrset acc) { } projects;
}
