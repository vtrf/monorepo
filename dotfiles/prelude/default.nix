inputs:

let
  lib = inputs.nixpkgs.lib;
in
rec {
  mkNixpkgs =
    { nixpkgs ? inputs.nixpkgs
    , system
    }:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nur.overlay
        (import ../overlay { inherit inputs system; })
      ];
    };

  mkHost =
    { host
    , username
    , system ? "x86_64-linux"
    , nixosModules ? [ ]
    , homeModules ? [ ]
    , nixpkgs ? inputs.nixpkgs
    }:
    let pkgs = mkNixpkgs { inherit nixpkgs system; };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit pkgs inputs system nixpkgs;
        inherit (inputs) homeManager nur hardware;
      };

      modules =
        nixosModules
        ++ [
          # home manager
          inputs.homeManager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users."${username}" = {
                imports = homeModules;
              };
              extraSpecialArgs = {
                inherit inputs pkgs nixpkgs username;
              };
            };
          }
        ];
    };

  mkHome =
    { username
    , system
    , homeModules ? [ ]
    , nixpkgs ? inputs.nixpkgs
    }:
    let
      pkgs = mkNixpkgs { inherit system; };
    in
    inputs.homeManager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = homeModules;
      extraSpecialArgs = {
        inherit pkgs inputs nixpkgs system username;
      };
    };
}
