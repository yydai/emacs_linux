(setq deft-extensions '("org" "md"))
(setq deft-directory "~/workspace/personal-notes")
(setq deft-recursive t)
(setq deft-auto-save-interval 20)

(setq deft-file-naming-rules
      '((noslash . "-")
        (nospace . "-")
        (case-fn . downcase)))

(global-set-key (kbd "C-x C-g") 'deft-find-file)
(global-set-key [f8] 'deft)


;; http://pragmaticemacs.com/category/deft/
(defun bjm-deft (dir)
  "Run deft in directory DIR"
  (setq deft-directory dir)
  (switch-to-buffer "*Deft*")
  (kill-this-buffer)
  (deft)
  )

(global-set-key (kbd "C-c d")
                (lambda () (interactive) (bjm-deft "~/workspace/personal-notes")))


;; new feature
;; for quick notes
(defun bjm-deft-save-windows (orig-fun &rest args)
  (setq bjm-pre-deft-window-config (current-window-configuration))
  (apply orig-fun args)
  )

(advice-add 'deft :around #'bjm-deft-save-windows)

(defun bjm-quit-deft ()
  "Save buffer, kill buffer, kill deft buffer, and restore window config to the way it was before deft was invoked"
  (interactive)
  (save-buffer)
  (kill-this-buffer)
  (switch-to-buffer "*Deft*")
  (kill-this-buffer)
  (when (window-configuration-p bjm-pre-deft-window-config)
    (set-window-configuration bjm-pre-deft-window-config)
    )
  )

(global-set-key (kbd "C-c q") 'bjm-quit-deft)

(provide 'init-deft)
