{ pkgs, ... }:

let
  inherit (pkgs) emacs;
in
{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./config;
    emacsPackage = emacs;
  };

  # LSPs
  home.packages = with pkgs; [
    gopls
    nodePackages.pyright
    rust-analyzer
  ];
}
