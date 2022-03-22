{
  description = "My personal dotfiles";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";

    utils.url = "github:numtide/flake-utils";

    hardware.url = "github:NixOS/nixos-hardware";
    homeManager.inputs.nixpkgs.follows = "unstable";
    homeManager.url = "github:nix-community/home-manager";
    nixColors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/nur";
  };

  outputs = { ... }@inputs:
    let prelude = import ./prelude inputs;
    in
    {
      nixosConfigurations = {
        t495 = prelude.mkHost {
          host = "t495";
          system = "x86_64-linux";
          username = "victor";
          nixosModules = [
            ./modules/meta.nix
            ./nixos/cli.nix
            ./nixos/nix.nix
            ./nixos/user.nix

            ./hosts/t495/hardware-configuration.nix

            inputs.hardware.nixosModules.lenovo-thinkpad-t495
          ];

          homeModules = [
            ./home/bash.nix
            ./home/chromium.nix
            ./home/cli.nix
            ./home/dconf.nix
            ./home/direnv.nix
            ./home/email.nix
            ./home/firefox.nix
            ./home/git.nix
            ./home/gui.nix
            ./home/home.nix
            ./home/kitty.nix
            ./home/neovim.nix
            ./home/newsboat.nix
            ./home/rbw.nix
            ./home/vscodium.nix

            ./modules/meta.nix

            inputs.nixColors.homeManagerModule
          ];
        };

        rpi3 = prelude.mkHost {
          host = "rpi3";
          system = "aarch64-linux";
          username = "victor";
          nixosModules = [
            ./modules/meta.nix
            ./nixos/cli.nix
            ./nixos/nix.nix
            ./nixos/user.nix

            ./hosts/rpi3

            "${inputs.unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];
        };
      };

      homeConfigurations = {
        # `home-manager switch --flake ".#work"`
        # `nix build ".#homeConfigurations.work.activationPackage"`
        work = prelude.mkHome {
          system = "x86_64-linux";
          username = "victor";
          homeModules = [
            ./home/bash.nix
            ./home/chromium.nix
            ./home/cli.nix
            ./home/dconf.nix
            ./home/direnv.nix
            ./home/email.nix
            ./home/firefox.nix
            ./home/git.nix
            ./home/home.nix
            ./home/neovim.nix
            ./home/newsboat.nix
            ./home/rbw.nix
            ./home/vscodium.nix

            ./modules/meta.nix

            inputs.nixColors.homeManagerModule
          ];
        };
      };

      templates = import ./templates;
    } // inputs.utils.lib.eachDefaultSystem (system:
      let pkgs = prelude.mkNixpkgs { inherit system; };
      in
      {
        devShell = with pkgs; mkShell {
          buildInputs = [
            nixpkgs-fmt
            rnix-lsp
          ];
        };
      }
    );
}
