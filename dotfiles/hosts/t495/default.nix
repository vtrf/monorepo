{ config, lib, hardware, nixpkgs, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # Set your time zone.
  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  networking = {
    hostName = "t495";
    networkmanager.enable = true;
  };

  environment = {
    etc = {
      "nix/channels/nixpkgs".source = nixpkgs;
    };

    systemPackages = with pkgs; [
      gnome.gnome-boxes
    ];
  };

  system.stateVersion = "22.05";
}
