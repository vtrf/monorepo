;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Code:
(persp-mode)

(setq user-full-name "Victor Freire"
      user-mail-address "victor@freire.dev.br")

;; ui
(setq doom-theme 'doom-tomorrow-night
      display-line-numbers-type t)

;; org
(setq org-directory "~/org/")

;; nix
(setq nix-nixfmt-bin "nixpkgs-fmt")

;; notmuch
(setq +notmuch-home-function (lambda () (notmuch-search "tag:inbox"))
      +notmuch-sync-backend 'mbsync)
