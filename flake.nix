{
  description = "My personal dotfiles";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";
    homeManager.inputs.nixpkgs.follows = "unstable";
    homeManager.url = "github:nix-community/home-manager";
    nixColors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/nur";
  };

  outputs = { ... }@inputs:
    let
      prelude = import ./prelude inputs;
    in
    {
      nixosConfigurations = {
        bootstrap = prelude.mkHost {
          host = "t495";
          system = "x86_64-linux";
          username = "victor";
          nixosModules = [
            ./modules/meta.nix
            ./nixos/nix.nix
            ./nixos/user.nix

            ./hosts/t495/hardware-configuration.nix

            inputs.hardware.nixosModules.lenovo-thinkpad-t495
          ];
        };

        earth = prelude.mkHost {
          host = "earth";
          system = "x86_64-linux";
          username = "victor";
          nixosModules = [
            ./modules/meta.nix
            ./nixos/cli.nix
            ./nixos/nix.nix
            ./nixos/user.nix

            ./hosts/t495/hardware-configuration.nix

            inputs.agenix.nixosModule
            inputs.hardware.nixosModules.lenovo-thinkpad-t495
          ];

          homeModules = [
            ./home/bash.nix
            ./home/chromium.nix
            ./home/cli.nix
            ./home/dconf.nix
            ./home/email.nix
            ./home/firefox.nix
            ./home/git.nix
            ./home/gui.nix
            ./home/home.nix
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

            ({ pkgs, ... }: {
              home.packages = with pkgs; [
                kubectl
                google-cloud-sdk
                fzfpods
              ];
            })
          ];
        };
      };

      templates = import ./templates;
    };
}
