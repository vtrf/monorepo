{ config, pkgs, ... }:

{
  hardware = {
    enableRedistributableFirmware = pkgs.lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
  };

  networking = {
    hostName = "mars";
    firewall.enable = true;
    networkmanager.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
