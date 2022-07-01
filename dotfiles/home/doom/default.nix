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
}
