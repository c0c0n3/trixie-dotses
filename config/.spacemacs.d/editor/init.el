;; Spacemacs editor configuration.

(load-rel "edit.el")
(load-rel "frame.el")
(load-rel "layers.el")
(load-rel "shell.el")
(load-rel "speedbar.el")
(load-rel "theme.el")


(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-configuration-layers (layers/list)
   dotspacemacs-excluded-packages '(;; get rid of tildes on empty lines.
                                    vi-tilde-fringe)
   dotspacemacs-additional-packages '(all-the-icons all-the-icons-dired)
   )
  )
;; NOTES
;; 1. Dired. When in Dired (C-x d) I want to use 'a' to visit directories
;; and when using 'a' the directory buffer should be reused instead of
;; creating a new one for each visited dir:
;;     (put 'dired-find-alternate-file 'disabled nil)
;; Likely Spacemacs does that already somewhere in those config layers.
;; 2. Spell-check comments. Already configured in those layers. Yay!
;; 3. Icon add-ons. 'all-the-icons' makes font icons available to Emacs
;; packages. NeoTree (which ships with Spacemacs) has built-in support
;; for it and 'dired' is supported through 'all-the-icons-dired'. Besides
;; configuring NeoTree and 'dired' to use 'all-the-icons' (see 'theme.el'),
;; you also have to install the icon fonts---details on 'all-the-icons' site.

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (frame/init)
  (edit/init)
  (theme/init)
  )


(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )


(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  (edit/user-config)
  (shell/user-config)
  (speedbar/user-config)
  (theme/user-config)
  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
