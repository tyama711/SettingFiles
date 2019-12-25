;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-theme 'doom-solarized-dark)

(global-visual-line-mode t)

(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

(map! :leader                           ; Use leader key from now on
      :desc "Find file in project dwim" "p F" #'counsel-projectile-find-file-dwim
      :desc "Search project dwim" "s P" #'+default/search-project-for-symbol-at-point)
