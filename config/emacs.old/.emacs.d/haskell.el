;; Haskell mode settings
;; see: http://haskell.github.io/haskell-mode/manual/latest/

(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode/")
(require 'haskell-mode-autoloads)
(add-to-list 'Info-default-directory-list "/usr/share/emacs/site-lisp/haskell-mode/")


;; turn on unicode input method
;; you can simply type ‘->’ and it is immediately replaced with ‘→’. 
;; M-x describe-input-method RET haskell-unicode: table of all key sequences
;; C-\: toggle mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)

;; we can't use Monaco in the Haskell mode buffer if unicode input is enabled as Monaco
;; doesn't have all the unicode symbols we need; so we switch to DejaVu Sans Mono.
;; Other buffers are not affected---see: http://www.emacswiki.org/emacs/FacesPerBuffer
(defun set-haskell-unicode-font ()
   (interactive)
   (setq buffer-face-mode-face '(:family "DejaVu Sans Mono" :height 120))
   (buffer-face-mode))
(add-hook 'haskell-mode-hook 'set-haskell-unicode-font)


;; indentation, choose one of the following
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


;; compilation: C-c C-c 
(eval-after-load "haskell-mode"
    '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))
(eval-after-load "haskell-cabal"
    '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))
