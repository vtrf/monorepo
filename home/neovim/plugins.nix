{ config, pkgs, inputs, ... }:

let
  inherit (pkgs)
    fetchFromGitHub
    lua53Packages
    vimPlugins
    vimUtils;

  inherit (inputs.nixColors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;

  cmp-nvim-lsp-signature-help = vimUtils.buildVimPlugin {
    name = "cmp-nvim-lsp-signature-help";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp-signature-help";
      rev = "3048f48";
      sha256 = "sha256-xl+Yp+KWbAwSACFv8XeLFPVdJHDby4rS1nYJLD47wpU=";
    };
  };
in
with vimPlugins; [
  # Theme
  {
    plugin = vimThemeFromScheme { scheme = config.colorscheme; };
    config = "colorscheme nix-${config.colorscheme.slug}";
  }

  # Lua libs
  plenary-nvim
  popup-nvim

  # vim-polyglot
  telescope-nvim

  # lsp
  nvim-lspconfig

  # Completion
  nvim-cmp
  cmp-nvim-lsp
  cmp-nvim-lsp-signature-help
  cmp-buffer
  cmp-path
  cmp-cmdline
  cmp-nvim-lua
  cmp-emoji
  luasnip
  cmp_luasnip

  {
    plugin = todo-comments-nvim;
    type = "lua";
    config = ''
      require('todo-comments').setup{}
    '';
  }
  {
    plugin = (nvim-treesitter.withPlugins (plugins:
      with plugins; [
        # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
        tree-sitter-bash
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
]
