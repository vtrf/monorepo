{ inputs, system, ... }:

final: prev: {
  # Custom packages
  cli-tools = import ../pkgs/cli-tools.nix { pkgs = final; };
  fzfpods = import ../pkgs/fzfpods.nix { pkgs = prev; };
}
