{ pkgs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./config;
    emacsPackage = pkgs.emacsPgtkNativeComp;
  };

  # LSPs
  home.packages = with pkgs; [
    gopls
    nodePackages.pyright
    rust-analyzer
  ];
}
