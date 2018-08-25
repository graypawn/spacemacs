;;; packages.el --- deft Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: graypawn <choi.pawn @gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq deft-ice-packages
  '(deft))

(defun deft-ice/init-deft ()
  (use-package deft
    :defer t
    :init
    (progn
      (setq 
            deft-extensions '("org" "md" "txt")
            deft-text-mode 'org-mode
            deft-use-filename-as-title t
            deft-use-filter-string-for-filename t)
      (spacemacs/set-leader-keys "an" 'spacemacs/deft)

      (defun spacemacs/deft ()
        "Helper to call deft and then fix things so that it is nice and works"
        (interactive)
        (deft)
        ;; Hungry delete wrecks deft's DEL override
        (when (fboundp 'hungry-delete-mode)
          (hungry-delete-mode -1))
        ;; When opening it you always want to filter right away
        (evil-insert-state nil))

      (defun graypawn/deft-ice ()
        "Run deft in specified directory."
        (interactive)
        (let ((directory (->> (default-value 'deft-directory)
                              (read-directory-name "Deft: "))))
          (make-directory directory t)
          (setq mode-line-process
                (->> (default-value 'deft-directory)
                     (file-relative-name directory)
                     (directory-file-name)
                     (format " in %s")))
          ;; Run deft.
          (let ((deft-directory directory))
            (deft))
          ;; Setting local value in deft buffer. And refresh.
          (set (make-local-variable 'deft-directory) directory)) 
        (deft-filter-clear) 
        (deft-refresh)
        ;; Hungry delete wrecks deft's DEL override)
        (when (fboundp 'hungry-delete-mode)
          (hungry-delete-mode -1))
        ;; When opening it you always want to filter right away
        (evil-insert-state nil)
        ))
    :config
    (bind-key "<tab>" 'graypawn/deft-ice deft-mode-map)
    (spacemacs/set-leader-keys-for-major-mode 'deft-mode
              "d" 'deft-delete-file
              "i" 'deft-toggle-incremental-search
              "n" 'deft-new-file
              "r" 'deft-rename-file)))
