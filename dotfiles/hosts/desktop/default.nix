{ config, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.useOSProber = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Set your time zone.
  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  system.stateVersion = "22.11";
}
