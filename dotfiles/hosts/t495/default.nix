{ config, lib, hardware, homeManager, nixpkgs, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModprobeConfig = ''
      options hid_apple fnmode=0
    '';

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    cleanTmpDir = true;
    consoleLogLevel = 7;
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

  # Enable sound.
  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    ledger.enable = true;
    pulseaudio.enable = false;
  };

  programs = {
    dconf.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      libinput.enable = true;

      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  environment = {
    etc = {
      "nix/channels/nixpkgs".source = nixpkgs;
      "nix/channels/home-manager".source = homeManager;
    };

    systemPackages = with pkgs; [
      gnome.gnome-boxes
    ];
  };

  system.stateVersion = "22.05";
}
