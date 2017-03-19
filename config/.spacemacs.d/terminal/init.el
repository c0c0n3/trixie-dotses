;; Spacemacs-based terminal emulator.

(load-rel "frame.el")
(load-rel "term.el")
(load-rel "../editor/edit.el")
(load-rel "../editor/theme.el")

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-configuration-layers '()
   dotspacemacs-excluded-packages '(eval-sexp-fu
                                    evil-anzu
                                    evil-search-highlight-persist
                                    evil-surround
                                    flx-ido
                                    helm   ;; keep?
                                    ido-vertical-mode
                                    info+  ;; keep?
                                    ;; page-break-lines ;; something else needs it...
                                    persp-mode
                                    popwin  ;; keep?
                                    smartparens
                                    vi-tilde-fringe
                                    volatile-highlights
                                    undo-tree
                                    which-key ;; keep?
                                    window-numbering
                                    ws-butler)
   ;; Do *not* delete any orphan packages as they're needed by
   ;; '~/.spacemacs.d/init.el'.
   dotspacemacs-install-packages 'used-but-keep-unused)
  )
;; NOTE
;; 1. Excluding the above packages results in slightly shorter startup times
;; (~300ms on my VM). But now I have to maintain this list and also am not
;; sure about package deps. (I looked at the loaded modes with 'C-h m' to come
;; up with the above list, not very safe!) Don't think the small performance
;; gain is worth the hassle though...

(defun dotspacemacs/init ()
  (frame/init)
  (edit/init)
  (theme/init)
  )

(defun dotspacemacs/user-init ()
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
