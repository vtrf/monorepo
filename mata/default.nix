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
    pandoc
    ;

  name = "mata";
in
rec {
  apps.mata = utils.lib.mkApp { drv = packages.mata; };
  packages.mata = buildGoModule {
    inherit name;
    src = lib.cleanSource ./.;

    nativeBuildInputs = [ pandoc ];

    vendorSha256 = "sha256-Dw0bIIssEd8UEh+pnd+Nk7RP72+HvHTGwJlOpCOQRG8=";

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
        gnumake
        go
        pandoc
        delve
        go-outline
        golangci-lint
        gomodifytags
        gopls
        gopkgs
        gotests
        impl
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
