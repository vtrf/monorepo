;;; export --- used to export my org-roam notes with ox-hugo

(require 'ox)
(require 'org)

;; org
(setq org-directory "."
      org-id-locations-file ".orgids"

      org-hugo-default-section-directory "notes"
      org-hugo-base-dir "notes")

(defun export-all ()
  (dolist (org-file (directory-files-recursively ".." "\.org$"))
    (with-current-buffer (find-file org-file)
      (message (format "[build] Exporting %s" org-file))
      (org-hugo-export-wim-to-md :all-subtrees nil nil nil))))

(export-all)

;;; export.el ends here
