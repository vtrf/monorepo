{ pkgs, ... }:

let
  firefox = "${pkgs.firefox}/bin/firefox";
  mpv = "${pkgs.mpv}/bin/mpv";
in
{
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      urls-source "opml"
      opml-url "https://glorifiedgluer.com/blogroll.xml"

      # misc
      refresh-on-startup yes

      # display
      feed-sort-order lastupdated
      text-width         72

      # navigation
      bind-key j down feedlist
      bind-key k up feedlist
      bind-key j next articlelist
      bind-key k prev articlelist
      bind-key J next-feed articlelist
      bind-key K prev-feed articlelist
      bind-key j down article
      bind-key k up article

      # macros
      macro v set browser "${mpv} %u" ; open-in-browser ; set browser "${firefox} %u" -- "Open video on mpv"
    '';
  };
}
