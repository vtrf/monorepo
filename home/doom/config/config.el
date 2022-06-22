;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Code:
(persp-mode)

(setq user-full-name "Victor Freire"
      user-mail-address "victor@freire.dev.br")

;; ui
(setq doom-theme 'doom-tomorrow-night
      display-line-numbers-type t)

;; treemacs
(after! treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;; nix
(setq nix-nixfmt-bin "nixpkgs-fmt")

;; notmuch
(setq +notmuch-home-function (lambda () (notmuch-search "tag:inbox"))
      +notmuch-sync-backend 'mbsync)

;; org
(setq org-directory "~/org/")
