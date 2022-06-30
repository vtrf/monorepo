{ config, inputs, username, nixpkgs, ... }:

let
  inherit (inputs) nixColors;
  inherit (config.meta) username;
in
{
  colorscheme = nixColors.colorSchemes.monokai;
  fonts.fontconfig.enable = true;

  nix.registry.nixpkgs.flake = nixpkgs;

  meta = {
    username = "victor";
    email = "victor@freire.dev.br";
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "20.09";
  };
}
