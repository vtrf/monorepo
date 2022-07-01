{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
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
}
