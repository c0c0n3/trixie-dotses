;; Spacemacs variables configuration.
;; You should not put any user code in this function besides overriding the
;; Spacemacs variables you want to change from their defaults.
(defun frame/init ()
  (setq-default
   ;; Maximise frame when Emacs starts up.
   ;; 'dotspacemacs-fullscreen-at-startup' must be nil for this to work.
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-maximized-at-startup t

   ;; Active and inactive frame transparency percentage (100 = opaque).
   ;; These settings seem to have no effect though; regardless of the value I
   ;; always get fully opaque frames.
   dotspacemacs-active-transparency 100
   dotspacemacs-inactive-transparency 70

   ;; Enable smooth scrolling (native-scrolling). This overrides Emacs default
   ;; behavior which recenters the point when it reaches the top or bottom of
   ;; the screen.
   dotspacemacs-smooth-scrolling t

   ;; Show line numbers when in 'prog-mode' or 'text-mode'.
   dotspacemacs-line-numbers t
   )
  )
;; NOTE
;; 1. Think Spacemacs hides the initial splash screen with
;;     (setq inhibit-startup-screen t)
;; but replaces it with its own buffer ("spacemacs").
;; Could not find a clean way to hide the "spacemacs" buffer---for an
;; acceptable solution, look at 'terminal/frame.el'.
;;
;; 2. Could display a scroll bar on the right with
;;     (scroll-bar-mode (quote right))
;; but smooth scrolling works quite well, so I don't think I'll ever need a
;; scroll bar again!
;;
;; 3. Could show line numbers always in the margin (fringe), regardless of
;; mode:
;;     (global-linum-mode 1)
;; but think Spacemacs settings are the best as I only really like seeing line
;; numbers when editing source code or writing text.
;;
;; 4. I like the status bar (mode line) to show the line/column number the
;; cursor is on:
;;     (line-number-mode 1)
;;     (column-number-mode t)
;; Likely Spacemacs does that already, so the above is redundant.
