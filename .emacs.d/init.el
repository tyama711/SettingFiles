;; Cask
(require 'cask
         (if (eq system-type 'darwin)
             "/usr/local/Cellar/cask/0.8.4/cask.el"
           ;;else
           "$HOME/.cask/cask.el"
           ))
(cask-initialize)

(setq default-tab-width 4)
;;(keyboard-translate ?\C-h ?\C-?)
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(global-set-key (kbd "M-?") 'help-for-help)
(global-linum-mode 1)
(tool-bar-mode 0)
(setq inhibit-startup-message t)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;;; 複数行移動
(global-set-key "\M-n" (kbd "C-u 5 C-n"))
(global-set-key "\M-p" (kbd "C-u 5 C-p"))


;; https://stackoverflow.com/questions/13517910/yank-does-not-paste-text-when-using-emacs-over-ssh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; handle copy/paste intelligently
(defun copy-from-osx ()
  "Handle copy/paste intelligently on osx."
  (let ((pbpaste (purecopy "/usr/bin/pbpaste")))
    (if (and (eq system-type 'darwin)
             (file-exists-p pbpaste))
        (let ((tramp-mode nil)
              (default-directory "~"))
          (shell-command-to-string pbpaste)))))

(defun paste-to-osx (text &optional push)
  "Handle copy/paste intelligently on osx.
TEXT gets put into the Macosx clipboard.

The PUSH argument is ignored."
  (let* ((process-connection-type nil)
         (proc (start-process "pbcopy" "*Messages*" "pbcopy")))
    (process-send-string proc text)
    (process-send-eof proc)))

(if (eq system-type 'darwin)
    (setq interprogram-cut-function 'paste-to-osx
      interprogram-paste-function 'copy-from-osx))

;; ;; commandキーをmetaキーとして使用
;; (when (eq system-type 'darwin)
;;   (setq ns-command-modifier (quote meta)))

;; バックアップファイル（foo.txt~）の保存先を設定
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups")))

;; font
(set-face-attribute 'default nil
:family "Liberation Mono" ;;font
:height 160) ;;font size


;; helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)
(helm-popup-tip-mode)

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
 '(flycheck-display-errors-delay 0.5)
 '(flycheck-display-errors-function
   (lambda
     (errors)
     (let
         ((messages
           (mapcar
            (function flycheck-error-message)
            errors)))
       (popup-tip
        (mapconcat
         (quote identity)
         messages "
")))))
 '(helm-tramp-verbose 8)
 '(indent-tabs-mode nil)
 '(package-selected-packages
   (quote
    (yasnippet-snippets web-mode use-package undohist undo-tree tide smex smartparens region-bindings-mode rainbow-delimiters projectile prodigy popwin pallet nyan-mode multiple-cursors markdown-mode magit jedi iedit idle-highlight-mode htmlize helm-tramp groovy-mode gradle-mode ggtags flycheck-irony flycheck-cask expand-region exec-path-from-shell drag-stuff company-php clang-format auto-save-buffers-enhanced anzu))))
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


;;(add-hook 'python-mode-hook 'jedi:setup)
;;(setq jedi:complete-on-dot t)


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
(cond ((>= emacs-major-version 25)
    (require 'ggtags)
    (add-hook 'java-mode-hook (lambda () (ggtags-mode 1)))
    (add-hook 'c-mode-hook (lambda () (ggtags-mode 1)))
    (add-hook 'c++-mode-hook (lambda () (ggtags-mode 1)))
    (add-hook 'python-mode-hook (lambda () (ggtags-mode 1)))
    (add-hook 'php-mode-hook (lambda () (ggtags-mode 1)))
    (setq ggtags-mode-hook
          '(lambda ()
             (local-set-key "\M-." 'ggtags-find-definition)    ;関数へジャンプ
             (local-set-key "\M-r" 'ggtags-find-reference)   ;関数の参照元へジャンプ
             (local-set-key "\M-s" 'ggtags-find-other-symbol) ;変数の定義元/参照先へジャンプ
             (local-set-key "\M-p" 'ggtags-prev-mark)   ;前のバッファに戻る
             (local-set-key "\M-n" 'ggtags-next-mark)   ;次のバッファに移る
             ))))

(require 'gradle-mode)
(gradle-mode 1)

(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

;; company-php settings
(add-hook 'php-mode-hook
          '(lambda ()
             (company-mode t)
             (ac-php-core-eldoc-setup) ;; enable eldoc
             (make-local-variable 'company-backends)
             (add-to-list 'company-backends 'company-ac-php-backend)))

;; tramp mode config
(setq tramp-default-method "ssh")
(setq tramp-auto-save-directory "~/emacs/tramp-autosave")
(setq auto-save-buffers-enhanced-exclude-regexps '("^/ssh:" "/sudo:" "/multi:"))

;; helm-tramp config
(define-key global-map (kbd "C-c s") 'helm-tramp)


;; tide mode settings from https://github.com/ananthakumaran/tide ;;;;;;;;;
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  (setq typescript-auto-indent-flag nil)
  (setq typescript-indent-level 2))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; ;; Prettierを使うためコメントアウト
;; ;; formats the buffer before saving
;; (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; prettier-js mode
(require 'prettier-js)
(add-hook 'typescript-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook
          (lambda()
            (prettier-js-mode)
            (setq web-mode-code-indent-offset 2)
            (setq web-mode-sql-indent-offset 2)
            (setq web-mode-css-indent-offset 2)
            (setq web-mode-attr-indent-offset 2)
            (setq web-mode-attr-value-indent-offset 2)
            (setq web-mode-markup-indent-offset 2)))
;; (setq prettier-js-args '(
;;   "--trailing-comma" "all"
;;   "--bracket-spacing" "false"
;; ))