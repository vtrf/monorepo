{ pkgs, ... }:

{
  home.packages = with pkgs.jetbrains; [
    goland
    rider
    idea-ultimate
  ];

  home.file.".ideavimrc".text = ''
    set visualbell
    set noerrorbells
    inoremap jk <Esc>
  '';
}
