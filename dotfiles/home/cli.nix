{ pkgs, ... }:

let
  inherit (pkgs) callPackage;
in
{
  programs = {
    aria2.enable = true;
    bat.enable = true;
    jq.enable = true;
  };

  home.packages = pkgs.cli-tools;

  programs.fzf.enable = true;
  home.sessionVariables = {
    EDITOR = "vi";
    FZF_DEFAULT_OPTS = ''--prompt \" λ \"'';
  };
}
