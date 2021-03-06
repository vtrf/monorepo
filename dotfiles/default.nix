{ inputs, ... }:

let
  prelude = import ./prelude inputs;
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
        ./nixos/secrets/t495.nix

        ./hosts/common/boot.nix
        ./hosts/common/graphical.nix
        ./hosts/common/virtualisation.nix

        ./hosts/t495/default.nix
        ./hosts/t495/hardware-configuration.nix

        inputs.hardware.nixosModules.lenovo-thinkpad-t495
        inputs.agenix.nixosModule
      ];

      homeModules = [
        ./home/aerc.nix
        ./home/bash.nix
        ./home/chromium.nix
        ./home/cli.nix
        ./home/dconf.nix
        ./home/doom
        ./home/email.nix
        ./home/firefox.nix
        ./home/git.nix
        ./home/gui.nix
        ./home/home.nix
        ./home/jetbrains.nix
        ./home/kitty.nix
        ./home/neovim
        ./home/newsboat.nix
        ./home/rbw.nix
        ./home/vscodium.nix

        ./modules/aerc.nix
        ./modules/meta.nix

        inputs.nixColors.homeManagerModule
        inputs.nixDoomEmacs.hmModule
      ];
    };

    rpi4 = prelude.mkHost {
      host = "rpi4";
      system = "aarch64-linux";
      username = "victor";
      nixosModules = [
        ./modules/meta.nix
        ./modules/argonone.nix
        ./nixos/nix.nix
        ./nixos/user.nix

        ./hosts/rpi4/dendrite.nix
        ./hosts/rpi4/nginx.nix
        ./hosts/rpi4/postgres.nix
        ./hosts/rpi4/hardware-configuration.nix

        ./nixos/secrets/rpi4.nix

        inputs.hardware.nixosModules.raspberry-pi-4
        inputs.agenix.nixosModule
      ];
    };

    desktop = prelude.mkHost {
      host = "desktop";
      system = "x86_64-linux";
      username = "victor";
      nixosModules = [
        ./modules/meta.nix
        ./nixos/cli.nix
        ./nixos/nix.nix
        ./nixos/user.nix
        ./nixos/secrets/t495.nix

        ./hosts/common/boot.nix
        ./hosts/common/graphical.nix
        ./hosts/common/virtualisation.nix

        ./hosts/desktop/hardware-configuration.nix
        ./hosts/desktop/default.nix

        inputs.agenix.nixosModule
      ];

      homeModules = [
        ./home/aerc.nix
        ./home/bash.nix
        ./home/chromium.nix
        ./home/cli.nix
        ./home/dconf.nix
        ./home/doom
        ./home/email.nix
        ./home/firefox.nix
        ./home/git.nix
        ./home/gui.nix
        ./home/home.nix
        ./home/jetbrains.nix
        ./home/kitty.nix
        ./home/neovim
        ./home/newsboat.nix
        ./home/rbw.nix
        ./home/vscodium.nix

        ./modules/aerc.nix
        ./modules/meta.nix

        inputs.nixColors.homeManagerModule
        inputs.nixDoomEmacs.hmModule
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
        ./home/cli.nix
        ./home/doom
        ./home/git.nix
        ./home/home.nix
        ./home/neovim
        ./home/newsboat.nix
        ./home/rbw.nix

        ./modules/meta.nix

        inputs.nixColors.homeManagerModule
        inputs.nixDoomEmacs.hmModule

        ({ pkgs, ... }: {
          home.packages = with pkgs; [
            fzfpods
          ];
        })
      ];
    };
  };

  templates = import ./templates;
}
