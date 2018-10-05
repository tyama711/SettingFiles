;; Cask
(require 'cask "/usr/local/Cellar/cask/0.8.4/cask.el")
(cask-initialize)


(setq default-tab-width 4)
(keyboard-translate ?\C-h ?\C-?)
(global-linum-mode 1)
(tool-bar-mode 0)
(setq inhibit-startup-message t)

;; クリップボードへコピーする
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx))

;; ;; commandキーをmetaキーとして使用
;; (when (eq system-type 'darwin)
;;   (setq ns-command-modifier (quote meta)))

;; バックアップファイル（foo.txt~）の保存先を設定
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups")))

;; font
(set-face-attribute 'default nil
:family "Liberation Mono" ;;font
:height 180) ;;font size


;; helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(helm-autoresize-mode t)
(setq helm-autoresize-max-height 50)
(setq helm-autoresize-min-height 30)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)
(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(define-key helm-command-prefix (kbd "o") 'helm-occur)
(setq helm-apropos-fuzzy-match t)
(setq helm-lisp-fuzzy-completion t)
(define-key helm-command-prefix (kbd "SPC") 'helm-all-mark-rings)
(setq helm-surfraw-default-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")
(define-key helm-command-prefix (kbd "g") 'helm-google-suggest)

;; ;; For find-file etc.
;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; (define-key helm-read-file-map (kbd "<right>") 'helm-select-action)
;; ;; For helm-find-files etc.
;; (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;; (define-key helm-find-files-map (kbd "<right>") 'helm-select-action)


;; ;; c-modeの設定
;; (add-hook 'c-mode-hook
;; 		  (setq c-tab-always-indent nil))
;; (add-hook 'c-mode-hook
;; 		  (setq c-basic-offset 4))

;; (add-hook 'c++-mode-hook
;; 		  (setq c-tab-always-indent nil))
;; (add-hook 'c++-mode-hook
;; 		  (setq c-basic-offset 4))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-default-style
   (quote
    ((c-mode . "bsd")
     (c++-mode . "bsd")
     (java-mode . "java")
     (awk-mode . "awk"))))
 '(indent-tabs-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'yasnippet)
(eval-after-load "yasnippet"
  '(progn
     ;; Translate the problematic keys to the function key Hyper:
     (keyboard-translate ?\C-i ?\H-i)
     ;; (keyboard-translate ?\C-m ?\H-m)
     ;; companyと競合するのでyasnippetのフィールド移動は "C-i" のみにする
     (define-key yas-keymap [(tab)] nil)
     (define-key yas-keymap (kbd "TAB") nil)
     (define-key yas-minor-mode-map [(tab)] nil)
     (define-key yas-minor-mode-map (kbd "TAB") nil)
     (global-set-key [?\H-i] 'yas-expand)
     (yas-global-mode 1)))


(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;; flycheck
;;(add-hook 'after-init-hook #'global-flycheck-mode)
(when (require 'flycheck nil 'noerror)
  (custom-set-variables
   ;; エラーをポップアップで表示
   '(flycheck-display-errors-function
     (lambda (errors)
       (let ((messages (mapcar #'flycheck-error-message errors)))
         (popup-tip (mapconcat 'identity messages "\n")))))
   '(flycheck-display-errors-delay 0.5))
  (define-key flycheck-mode-map (kbd "C-M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-M-p") 'flycheck-previous-error)
  (add-hook 'c-mode-common-hook 'flycheck-mode))


;; company
(when (locate-library "company")
  (global-company-mode 1)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
  (setq company-dabbrev-downcase nil))


;; irony
(defun my-irony-mode-on ()
  ;; avoid enabling irony-mode in modes that inherits c-mode, e.g: php-mode
  (when (member major-mode irony-supported-major-modes)
    (custom-set-variables '(irony-additional-clang-options '("-std=c++14")))
    (add-to-list 'company-backends 'company-irony)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
    (irony-mode 1)))

(eval-after-load "irony"
  '(progn
     (add-hook 'c-mode-common-hook 'my-irony-mode-on)))


;; flycheck-irony
(eval-after-load "flycheck"
  '(progn
     (when (locate-library "flycheck-irony")
       (flycheck-irony-setup))))

(add-hook 'c++-mode-hook
          (lambda ()
            (setq flycheck-clang-language-standard "c++14")
            (setq flycheck-gcc-language-standard "c++14")
            (setq company-clang-arguments '("-std=c++14"))
            )
          )


(require 'undohist)
(undohist-initialize)

(require 'undo-tree)
(global-undo-tree-mode t)

(require 'anzu)
(global-anzu-mode +1)

(require 'iedit)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'smartparens-config)
(add-hook 'prog-mode-hook #'smartparens-mode)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'multiple-cursors)
;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'region-bindings-mode)
(region-bindings-mode-enable)
(define-key region-bindings-mode-map "e" 'mc/edit-lines)
(define-key region-bindings-mode-map "a" 'mc/mark-all-like-this)
(define-key region-bindings-mode-map "p" 'mc/mark-previous-like-this)
(define-key region-bindings-mode-map "n" 'mc/mark-next-like-this)
(define-key region-bindings-mode-map "m" 'mc/mark-more-like-this-extended)

;; setting of HideShow Mode
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; setting of Semantic Mode
(add-hook 'prog-mode-hook #'semantic-mode)


(require 'clang-format)
(add-hook 'c++-mode-hook
          (lambda ()
            (global-set-key [C-M-tab] 'clang-format-region)
            (global-set-key (kbd "C-S-f") 'clang-format-buffer)
            (setq c-basic-offset 2)))


;; gnu-global
(require 'ggtags)
(add-hook 'java-mode-hook (lambda () (ggtags-mode 1)))
(add-hook 'c-mode-hook (lambda () (ggtags-mode 1)))
(add-hook 'c++-mode-hook (lambda () (ggtags-mode 1)))
(add-hook 'python-mode-hook (lambda () (ggtags-mode 1)))
(setq ggtags-mode-hook
    '(lambda ()
        (local-set-key "\M-t" 'ggtags-find-definition)    ;関数へジャンプ
        (local-set-key "\M-r" 'ggtags-find-reference)   ;関数の参照元へジャンプ
        (local-set-key "\M-s" 'ggtags-find-other-symbol) ;変数の定義元/参照先へジャンプ
        (local-set-key "\M-p" 'ggtags-prev-mark)   ;前のバッファに戻る
        (local-set-key "\M-n" 'ggtags-next-mark)   ;前のバッファに戻る
        ))


(require 'gradle-mode)
(gradle-mode 1)


(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 4)))


;; company-php settings
(add-hook 'php-mode-hook
          '(lambda ()
             (company-mode t)
             (ac-php-core-eldoc-setup) ;; enable eldoc
             (make-local-variable 'company-backends)
             (add-to-list 'company-backends 'company-ac-php-backend)))
