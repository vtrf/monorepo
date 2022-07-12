;;; export --- used to export my org-roam notes with ox-hugo

(require 'ox)
(require 'org)

(setq org-directory "."
      org-id-locations-file ".orgids")

(with-current-buffer (find-file "content.org")
  (message (format "exporting content/content.org context=build"))
  (org-hugo-export-wim-to-md :all-subtrees nil nil nil))

;;; export.el ends here
