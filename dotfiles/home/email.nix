{ config, pkgs, ... }:

let
  inherit (config.meta) email name;
  notmuch = "${pkgs.notmuch}/bin/notmuch";
in
{
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      new.tags = [ "unread" "inbox" ];
      hooks = {
        preNew = "mbsync --all";
        postNew = ''
          ${notmuch} tag +uber      -- tag:unread and from:noreply@uber.com
          ${notmuch} tag +nixos     -- tag:unread and from:discourse@discourse.nixos.org
          ${notmuch} tag +github    -- tag:unread and from:notifications@github.com
          ${notmuch} tag +sourcehut -- tag:unread and from:*@sr.ht or to:*@lists.sr.ht
        '';
      };
    };
  };

  accounts.email = {
    accounts.personal = {
      realName = name;
      address = email;
      userName = email;
      primary = true;

      imap.host = "imap.mailbox.org";
      smtp.host = "smtp.mailbox.org";
      passwordCommand = "rbw get mailbox.org";

      notmuch.enable = true;
      msmtp.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
      };

      signature = {
        text = ''
          ${name}
        '';
        showSignature = "append";
      };
    };
  };
}
