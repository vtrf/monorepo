final: prev: {
  # Custom packages
  cli-tools = import ../pkgs/cli-tools.nix { pkgs = final; };
  fzfpods = import ../pkgs/fzfpods.nix { pkgs = prev; };
  hut = import ../pkgs/hut.nix { pkgs = prev; };
}
