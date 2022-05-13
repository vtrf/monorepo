{ pkgs, utils, ... }:

let
  inherit (pkgs)
    buildGoModule
    lib
    mkShell

    delve
    gnumake
    go
    go-outline
    golangci-lint
    gomodifytags
    gopkgs
    gopls
    gotests
    impl
    scdoc
    ;

  name = "mata";
in
rec {
  apps.mata = utils.lib.mkApp { drv = packages.mata; };
  packages.mata = buildGoModule {
    inherit name;
    src = lib.cleanSource ./.;

    nativeBuildInputs = [ scdoc ];

    vendorSha256 = "sha256-4gbUCQXdqBt1m5mvSeG7UjL5IZyYjoNtDmHHJX6mboQ=";

    subPackages = [ "cmd/mata" ];

    makeFlags = [
      "PREFIX=$(out)"
    ];

    postBuild = ''
      make $makeFlags
    '';

    preInstall = ''
      make $makeFlags install
    '';

    meta = with lib; {
      homepage = "https://git.sr.ht/~glorifiedgluer/monorepo/mata";
      description = "A CLI tool for mataroa / mataroa.blog";
      license = licenses.mit;
      maintainers = with maintainers; [ ratsclub ];
    };
  };

  devShells = {
    mata = mkShell {
      buildInputs = [
        delve
        gnumake
        go
        go-outline
        golangci-lint
        gomodifytags
        gopkgs
        gopls
        gotests
        impl
        scdoc
      ];
    };

    mata-ci = mkShell {
      buildInputs = [
        gnumake
        go
        golangci-lint
      ];
    };
  };
}
