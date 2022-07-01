{ pkgs, ... }:

let
  inherit (pkgs) emacs;
in
{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./config;
    emacsPackage = emacs.override { withPgtk = true; };
  };

  # LSPs
  home.packages = with pkgs; [
    gopls
    nodePackages.pyright
    rust-analyzer
  ];
}
