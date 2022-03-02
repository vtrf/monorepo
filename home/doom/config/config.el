;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-
;;; Code:

(setq user-full-name "Victor Freire"
      user-mail-address "victor@freire.dev.br")

;;; :ui doom
(setq doom-font (font-spec :family "JetBrainsMono" :size 15)
      ivy-posframe-font (font-spec :family "JetBrainsMono" :size 15)
      doom-theme 'doom-tomorrow-night)

;;; :ui treemacs
(use-package! treemacs
  :config
  (treemacs-follow-mode t))

;;; :lang org
(setq org-directory "~/garden.freire.dev.br"

      ;; org-agenda
      org-log-done 'time
      org-agenda-start-with-log-mode t
      org-agenda-files (list
                        (concat org-directory "/private/tasks.org"))

      ;; roam
      org-roam-directory org-directory
      org-roam-capture-templates '(("d" "default" plain "%?" :target
                                    (file+head "%<%Y%m%d%H%M%S>.org" "#+title: ${title}\n")
                                    :unnarrowed t)))

(after! org
  (add-to-list 'org-modules 'org-habit))

;;; :lang nix
(setq nix-nixfmt-bin "nixpkgs-fmt")

;;; :tools rss
(setq elfeed-search-filter "@6-month-ago"
      rmh-elfeed-org-files (list
                            (concat org-directory "/private/feeds.org")))

;;; :app irc
(setq +notmuch-sync-backend 'mbsync)

(after! circe
  (defun my/rbw-get-secret (secret)
    (process-lines "rbw" "get" secret "--full"))

  (defun my/rbw-splitted-secret (secret position)
    (-second-item (split-string (nth position (my/rbw-get-secret secret)))))

  (set-irc-server! "chat.sr.ht"
    `(:tls t
      :port 6697
      :nick ,(my/rbw-splitted-secret "sourcehut" 1)
      :sasl-password ,(my/rbw-splitted-secret "sourcehut" 3)
      :sasl-username ,(format "%s/irc.libera.chat"
                              (my/rbw-splitted-secret "libera.chat" 1))
      :channels ("#norzilian" "#nixos"))))

;;; :email notmuch
(setq mail-signature "Victor Freire"
      +notmuch-home-function (lambda () (notmuch-search "tag:inbox")))

;;; config.el ends here
