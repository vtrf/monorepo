{ config, pkgs, ... }:

let
  inherit (config.meta) username;
in
{
  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
    ];

    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };

      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "rpi4";
    networkmanager.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users."${username}".openssh.authorizedKeys.keys;
}
