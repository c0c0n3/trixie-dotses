;; Spacemacs-based terminal emulator.

(load-rel "frame.el")
(load-rel "term.el")
(load-rel "../editor/edit.el")
(load-rel "../editor/theme.el")

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-configuration-layers '()
   dotspacemacs-distribution 'spacemacs-base
   ;; Do *not* delete any orphan packages as they're needed by
   ;; '~/.spacemacs.d/init.el'.
   dotspacemacs-install-packages 'used-but-keep-unused)
  )
;; NOTE
;; 1. Spacemacs load time. Using the `spacemacs-base' distribution avoids
;; loading tons of packages most of which I won't need for the shell and
;; so you get a shorter startup time---saves about 2 seconds on average.

(defun dotspacemacs/init ()
  (frame/init)
  (edit/init)
  (theme/init)
  )

(defun dotspacemacs/user-env ()
  ;; Env vars file not really needed since I usually start Emacs from a Nix
  ;; shell.
  ;; (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  )

(defun dotspacemacs/user-load ()
  )

(defun dotspacemacs/user-config ()
  (frame/user-config)
  (term/user-config)
  )
;; NOTE
;; 1. Do *not* enable CUA. (Enabled in 'edit/user-config'.). As noted in the
;; AnsiTerm docs, CUA keybindings interfere with the term keybindings and,
;; in fact, AnsiTerm disables CUA. However, 'term/user-config' remedies this
;; partially so we can still use Ctrl+v to paste from the clipboard when in
;; char mode. For line mode, you'll have to use Emacs bindings:  M-w (copy),
;; C-y (paste), etc.
