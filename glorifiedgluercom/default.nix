{ pkgs, ... }:

let
  inherit (pkgs)
    hugo
    hut
    lib
    mkShell
    stdenv
    writeShellApplication
    ;
in
{
  apps.glorifiedgluercom = rec {
    type = "app";
    script = writeShellApplication {
      name = "hugorun.sh";
      text = ''
        set -xe
        export PORT="''${HUGO_PORT:-7072}"
        cd ./glorifiedgluercom && ${hugo}/bin/hugo serve --port "$PORT"
      '';
    };
    program = "${script}/bin/hugorun.sh";
  };

  packages.glorifiedgluercom = stdenv.mkDerivation {
    name = "glorifiedgluercom";
    src = lib.cleanSource ./.;

    buildInputs = [ hugo ];

    buildPhase = ''
      hugo
      tar -cvzf site.tar.gz -C public .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r site.tar.gz $out
    '';
  };

  devShells.glorifiedgluercom-ci = mkShell {
    buildInputs = [ hut ];
  };
}
