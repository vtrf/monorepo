{ config, pkgs, ... }:

{
  hardware = {
    enableRedistributableFirmware = pkgs.lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
  };

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
