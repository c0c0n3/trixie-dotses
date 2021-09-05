;; Spacemacs editor configuration.

(load-rel "edit.el")
(load-rel "frame.el")
(load-rel "layers.el")
(load-rel "shell.el")
(load-rel "speedbar.el")
(load-rel "theme.el")


(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   dotspacemacs-configuration-layers (layers/list)
   dotspacemacs-excluded-packages '(;; get rid of tildes on empty lines.
                                    vi-tilde-fringe)
   dotspacemacs-additional-packages '()
   )
  )
;; NOTE
;; 1. Dired. When in Dired (C-x d) I want to use 'a' to visit directories
;; and when using 'a' the directory buffer should be reused instead of
;; creating a new one for each visited dir:
;;     (put 'dired-find-alternate-file 'disabled nil)
;; Likely Spacemacs does that already somewhere in those config layers.
;; 2. Spell-check comments. Already configured in those layers. Yay!


(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  (frame/init)
  (edit/init)
  (theme/init)
  )


(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  ;; Env vars file not really needed since I usually start Emacs from a Nix
  ;; shell.
  ;; (spacemacs/load-spacemacs-env)
  )


(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  )


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (edit/user-config)
  (shell/user-config)
  (speedbar/user-config)
  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
