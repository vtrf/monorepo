{ inputs, ... }:

let
  inherit (inputs) nixpkgs utils;
in
utils.lib.eachDefaultSystem
  (system:
  let
    pkgs = import nixpkgs { inherit system; };
    inherit (pkgs)
      emacs-nox
      emacsPackagesFor
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

    packages.glorifiedgluercom =
      let
        customEmacs = (emacsPackagesFor emacs-nox).emacsWithPackages
          (epkgs: with epkgs.melpaPackages; [
            ox-hugo
          ]
          ++ (with epkgs.elpaPackages; [
            org
          ]));
        notes = stdenv.mkDerivation {
          name = "notes";
          src = ../notes;

          buildInputs = [ customEmacs ];

          buildPhase = ''
            emacs $(pwd) --batch -load export.el
          '';

          installPhase = ''
            mkdir -p $out
            cp -r notes/content/notes/* $out
          '';
        };
      in
      stdenv.mkDerivation {
        name = "glorifiedgluercom";
        src = lib.cleanSource ./.;

        buildInputs = [ hugo ];

        configurePhase = ''
          mkdir -p content/notes
          cp -r ${notes}/* content/notes
        '';

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
  })
