{ config, pkgs, inputs, ... }:

let
  inherit (pkgs) fetchFromGitHub vimPlugins vimUtils;
in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = pkgs.callPackage ./plugins.nix { inherit config pkgs inputs; };

    extraConfig = ''
      lua require('init')
    '';

    extraPackages = with pkgs; [
      # LSPs
      gopls
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.pyright
      rnix-lsp
      rust-analyzer
      sumneko-lua-language-server
    ];
  };

  xdg.configFile = {
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
  };
}
