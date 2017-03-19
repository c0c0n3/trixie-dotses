;; solarized theme dowloaded from:
;; https://github.com/sellout/emacs-color-theme-solarized

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized t)

;; this seems to enable the theme in every frame except the speedbar...
(set-frame-parameter nil 'background-mode 'dark) ;; 'light or 'dark
;; the following line fixes it
(setq frame-background-mode 'dark) ;; 'light or 'dark
;; also if using the dark theme, speedbar icons look ugly, so disable them:
(setq speedbar-use-images nil)

(enable-theme 'solarized)

(set-face-attribute 'default nil :font "Monaco-12") 



;; Below is my old theme...

;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 117 :width normal :foundry "unknown" :family "Monaco"))))
;;  '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "Gray68"))))
;;  '(font-lock-constant-face ((((class color) (min-colors 88) (background light)) (:foreground "#FCA434" :weight bold))))
;;  '(font-lock-doc-face ((t (:inherit font-lock-string-face :foreground "Gray68"))))
;;  '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "#6EAAF3" :weight bold))))
;;  '(font-lock-keyword-face ((((class color) (min-colors 88) (background light)) (:foreground "#6EAAF3" :weight bold))))
;;  '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "RosyBrown"))))
;;  '(font-lock-variable-name-face ((t (:foreground "#FCA434" :weight normal :family "Monospace")))))


;; NOTE: to figure out which font-lock vars to set, you can postion the cursor on 
;; some text and then 'M-x describe-face'.  For complete color themes see:
;;  * http://emacs-fu.blogspot.com/2009/03/color-theming.html
