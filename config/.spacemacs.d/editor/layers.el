;; Spacemacs editor configuration.

;; Load custom layers function. If defined, we'll use it to override the
;; default layers below.
;; The function must be defined in a file named '.spacemacs.layers.el' in
;; your home, must be called 'custom-layers' and just return the list of
;; layers symbols as required by Spacemacs. Here's an example:
;;
;; (defun custom-layers ()
;;   '(auto-completion
;;     better-defaults
;;     emacs-lisp))
;;
(load-if "~/.spacemacs.layers.el")

(defun layers/defaults ()
  "Default Spacemacs layers to load."
  '(auto-completion
    better-defaults
    emacs-lisp
    git
    haskell
    markdown
    latex
    nixos
    (shell :variables
           shell-default-shell 'multi-term
           shell-default-height 30
           shell-default-position 'bottom)
    (spell-checking :variables
                    ispell-program-name "aspell"
                    ispell-dictionary "en_GB")
    syntax-checking
    version-control))

(defun layers/list ()
  "List Spacemacs layers to load."
  (if (fboundp 'custom-layers) (custom-layers) (layers/defaults)))
