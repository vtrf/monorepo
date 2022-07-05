{
  description = "My personal monorepo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # emacs-related
    emacs = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-emacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
    nixDoomEmacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.doom-emacs.follows = "doom-emacs";
      inputs.emacs-overlay.follows = "emacs";
    };

    hardware.url = "github:NixOS/nixos-hardware";
    homeManager.inputs.nixpkgs.follows = "nixpkgs";
    homeManager.url = "github:nix-community/home-manager";
    nixColors.url = "github:misterio77/nix-colors";

    nur.url = "github:nix-community/nur";
  };

  outputs = { self, ... }@inputs:
    let
      inherit (inputs) nixpkgs;
      inherit (nixpkgs) lib;
      projects = builtins.map (project: import project { inherit inputs; }) [
        ./capivarasdev
        ./dotfiles
        ./glorifiedgluercom
        ./mata
      ];
    in
    lib.foldr (attrset: acc: lib.recursiveUpdate attrset acc) { } projects;
}
