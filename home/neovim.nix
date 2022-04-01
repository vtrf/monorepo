{ config, pkgs, inputs, ... }:

let
  inherit (inputs) nixColors;
  inherit (nixColors.lib { inherit pkgs; }) vimThemeFromScheme;
  inherit (pkgs) fetchFromGitHub vimPlugins vimUtils;
in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with vimPlugins; [
      {
        plugin = vimThemeFromScheme { scheme = config.colorscheme; };
        config = "colorscheme nix-${config.colorscheme.slug}";
      }
      { plugin = vim-polyglot; }

      { plugin = telescope-nvim; }
      { plugin = plenary-nvim; }
      {
        plugin = pkgs.vimPlugins.todo-comments-nvim;
        config = ''
          lua require('todo-comments').setup{}
        '';
      }

      {
        plugin = (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
            tree-sitter-bash
            tree-sitter-beancount
            tree-sitter-bibtex
            tree-sitter-comment
            tree-sitter-css
            tree-sitter-fennel
            tree-sitter-go
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-latex
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-regex
            tree-sitter-rust
            tree-sitter-scss
            tree-sitter-svelte
            tree-sitter-toml
            tree-sitter-typescript
            tree-sitter-vim
            tree-sitter-yaml
          ])
        );
        type = "lua";
        config = ''
          require 'nvim-treesitter.configs'.setup {
            highlight = { enable = true },
            indent = { enable = true },
          }
        '';
      }
    ];

    # TODO https://github.com/nix-community/home-manager/pull/2391
    extraConfig = ''
      " show column ruler
      set colorcolumn=80

      " show numbers
      set number

      " show relative numbers
      set relativenumber

      " space as leader key
      nnoremap <space> <nop>
      let mapleader=' '

      " escape key
      inoremap jk <Esc>

      " Telescope
      nnoremap <leader>hs <cmd>Telescope help_tags<cr>
      nnoremap <leader>pf <cmd>Telescope find_files<cr>
      nnoremap <leader>ps <cmd>Telescope live_grep<cr>
      nnoremap <leader>pt <cmd>TodoTelescope<cr>
      nnoremap <leader>ss <cmd>Telescope buffers<cr>
    '';
  };
}
