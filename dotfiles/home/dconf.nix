{ config, pkgs, inputs, ... }:

let
  inherit (homeManager.lib.hm.gvariant) mkTuple;
  inherit (inputs) homeManager;
  inherit (pkgs) nixos-artwork;
  wallpaper = nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
in
{
  dconf.settings = {
    # custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "gnome-terminal";
      name = "Open terminal";
    };

    "org/gnome/desktop/peripherals/trackball" = {
      "middle-click-emulation" = true;
      "scroll-wheel-emulation-button" = 8;
    };
    "org/gnome/desktop/wm/preferences" = {
      "resize-with-right-button" = true;
    };
    "org/gnome/desktop/background" = {
      "picture-uri" = wallpaper;
    };
    "org/gnome/desktop/interface" = {
      "enable-hot-corners" = false;
      "show-battery-percentage" = true;
    };
    "org/gnome/mutter" = {
      "edge-tiling" = true;
    };
    "org/gnome/desktop/input-sources" = {
      "sources" = [
        (mkTuple [ "xkb" "us" ])
        (mkTuple [ "xkb" "br" ])
      ];
    };
  };
}
