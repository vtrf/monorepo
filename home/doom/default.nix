{ pkgs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./config;
  };

  # LSPs
  home.packages = with pkgs; [
    gopls
    nodePackages.pyright
    rust-analyzer
  ];
}
