{ config, inputs, username, nixpkgs, ... }:

let
  inherit (inputs) nixColors;
  inherit (config.meta) username;
in
{
  colorscheme = nixColors.colorSchemes.monokai;
  fonts.fontconfig.enable = true;

  nix.registry.nixpkgs.flake = nixpkgs;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.05";
  };
}
