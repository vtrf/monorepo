{ pkgs, ... }:

pkgs.buildGoModule rec {
  pname = "hut";
  version = "70566f28388534da2231b82b9b8b7aa8e2054eb3";

  src = builtins.fetchGit {
    url = "https://git.sr.ht/~emersion/hut";
    ref = "master";
    rev = version;
  };

  nativeBuildInputs = with pkgs; [ installShellFiles scdoc ];

  vendorSha256 = "sha256-zdQvk0M1a+Y90pnhqIpKxLJnlVJqMoSycewTep2Oux4=";

  postBuild = ''
    scdoc < doc/hut.1.scd > hut.1
    installManPage hut.1
  '';
}
