{ inputs, ... }:

let
  inherit (inputs) nixpkgs utils;
in
utils.lib.eachDefaultSystem (system:
let
  pkgs = import nixpkgs { inherit system; };
  inherit (pkgs)
    hut
    lib
    mkShell
    stdenv
    ;
in
{
  packages.capivarasdev = stdenv.mkDerivation {
    name = "capivarasdev";
    src = lib.cleanSource ./.;

    buildPhase = ''
      tar -cvzf site.tar.gz -C src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r site.tar.gz $out
    '';
  };

  devShells.capivaras-ci = mkShell {
    buildInputs = [ hut ];
  };
})
