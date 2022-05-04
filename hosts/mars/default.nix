{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    # tmpOnTmpfs = true; # See note
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "mars";
    networkmanager.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.victor.openssh.authorizedKeys.keys;
}
