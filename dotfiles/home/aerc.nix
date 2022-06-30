{ config, pkgs, ... }:

let
  c = config.colorscheme.colors;
in
{
  programs.aerc = {
    enable = true;
    conf = {
      ui = {
        index-format = "%-20.20D %-17.17n %Z %s";
        timestamp-format = "2006-01-02 03:04 PM";

        mouse-enabled = true;
        sidebar-width = 25;
        sort = "-r date";
        spinner = ",|,/,-";
      };
      viewer = {
        alternatives = "text/html,text/plain";
      };
      filters = {
        "text/plain" = "sed 's/^>\+.*/\x1b[36m&\x1b[0m/'";
        "text/html" = ''
          ${pkgs.w3m}/bin/w3m \
            -T text/html \
            -cols $(tput cols) \
            -dump \
            -o display_image=false \
            -o display_link_number=true
        '';
      };
    };
    styleset = {
      "*.default" = true;
      "*.selected.reverse" = "toggle";

      "*.selected.fg" = "#${c.base05}";
      "*.selected.bg" = "#${c.base00}";

      "title.reverse" = true;
      "header.bold" = true;

      "*error.bold" = true;
      "error.fg" = "#${c.base08}";
      "warning.fg" = "yellow";
      "success.fg" = "#${c.base0E}";

      "statusline*.default" = true;
      "statusline_default.reverse" = true;
      "statusline_error.fg" = "#${c.base08}";
      "statusline_error.reverse" = true;

      "msglist_unread.bold" = true;
      "msglist_deleted.fg" = "gray";
      "msglist_read.fg" = "#${c.base03}";

      "completion_pill.reverse" = true;

      "tab.reverse" = true;
      "border.reverse " = true;

      "selector_focused.reverse" = true;
      "selector_chooser.bold" = true;
    };
    queryMaps = [
      "Inbox=tag:inbox and not tag:archived"
      "GitHub=tag:github and not tag:archived"
      "Banking=tag:banking and not tag:archived"
      "SourceHut=tag:sourcehut and not tag:archived"
    ];
  };
}
