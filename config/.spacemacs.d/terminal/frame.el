(defun frame/init ()
  (setq-default
   ;; Maximise frame when Emacs starts up.
   ;; 'dotspacemacs-fullscreen-at-startup' must be nil for this to work.
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-maximized-at-startup t

   ;; Enable smooth scrolling (native-scrolling). This overrides Emacs default
   ;; behavior which recenters the point when it reaches the top or bottom of
   ;; the screen.
   dotspacemacs-smooth-scrolling t

   ;; Show line numbers when in 'prog-mode' or 'text-mode'.
   dotspacemacs-line-numbers t

   ;; Get rid of (most of) Spacemacs start up buffer and speedup loading time.
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists nil
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-check-for-update nil
   )
  )

(defun frame/user-config ()
  ;; Make the frame transparent.
  ;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
  (set-frame-parameter (selected-frame) 'alpha '(85 85))
  (add-to-list 'default-frame-alist '(alpha 85 85))
  )

;; Get rid of initial Spacemacs buffer.
(defun kill-spacemacs-buffer ()
  (kill-buffer (get-buffer spacemacs-buffer-name))
  )
(add-hook 'emacs-startup-hook 'kill-spacemacs-buffer 'append)


;; NOTE
;; 1. Think Spacemacs hides the initial splash screen with
;;     (setq inhibit-startup-screen t)
;; and replaces it with its own buffer ("spacemacs") which I managed to kill
;; but then I get an annoying message in the status bar:
;;     save-current-buffer: Wrong type argument: stringp, nil.
;; There must be a better way of doing this?
;; Note the 'append param: we have to add this hook at the rear of the
;; queue so it gets executed after Spacemacs own start up hook.
;;
;; 2. Could display a scroll bar on the right with
;;     (scroll-bar-mode (quote right))
;; but smooth scrolling works quite well, so I don't think I'll ever need a
;; scroll bar again!
;;
;; 3. Active and inactive frame transparency seem to have no effect; I
;; always get fully opaque frames:
;;     dotspacemacs-active-transparency 85
;;     dotspacemacs-inactive-transparency 85
;; so am forcing this setting in 'frame/user-config'.
;;
;; 4. There's no need to disable menu and toolbar:
;;     (tool-bar-mode -1)
;;     (menu-bar-mode -1)
;; as Spacemacs does that already.
