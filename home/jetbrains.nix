{ pkgs, ... }:

{
  home.packages = with pkgs.jetbrains; [
    goland
    rider
    idea-ultimate
  ];
}
