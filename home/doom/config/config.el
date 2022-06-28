;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Code:

(persp-mode)

(setq user-full-name "Victor Freire"
      user-mail-address "victor@freire.dev.br")

;; deft
(after! deft
  (setq deft-directory "~/monorepo/notes")
  (setq deft-extensions '("md" "org")))

;; kubernetes
(use-package kubernetes
  :defer
  :commands (kubernetes-overview))

(use-package kubernetes-evil
  :defer
  :after kubernetes)

(map! :leader
      (:prefix "o"
       :desc "Kubernetes" "K" 'kubernetes-overview))

;; nix
(setq nix-nixfmt-bin "nixpkgs-fmt")

;; notmuch
(setq +notmuch-home-function (lambda () (notmuch-search "tag:inbox"))
      +notmuch-sync-backend 'mbsync)

;; org
(setq org-directory "~/org/")

;; treemacs
(after! treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;; ui
(setq doom-theme 'doom-tomorrow-night
      display-line-numbers-type t)
