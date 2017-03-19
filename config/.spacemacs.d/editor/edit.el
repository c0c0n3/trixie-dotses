;; Spacemacs variables configuration.
;; You should not put any user code in this function besides overriding the
;; Spacemacs variables you want to change from their defaults.
(defun edit/init ()
  (setq-default
   ;; Use Emacs key bindings. (Holy mode.)
   dotspacemacs-editing-style 'emacs

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Delete white space on changed lines when saving the buffer.
   dotspacemacs-whitespace-cleanup 'changed

   ;; Disable auto-saving.
   dotspacemacs-auto-save-file-location nil
   ;; Note that the above seems to disable backup (filename~ file) and autosave
   ;; (#filename# file) too. So the following is redundant:
   ;;(setq backup-inhibited t)
   ;;(setq auto-save-default nil)
   ;;(setq make-backup-files nil)
   )
  )

;; Spacemacs user's configuration.
;; This is the place where most of your configurations should be done.
(defun edit/user-config ()
  ;; Set default major mode to be text instead of fundamental
  ;; 'M-x fundamental-mode' takes you back to fundamental mode
  (setq-default major-mode 'text-mode)

  ;; Enable CUA mode (‘C-v’ to paste, ‘C-c’ to copy, ‘C-x’ to cut, ‘C-z’ to
  ;; undo, etc.)
  (cua-mode t)
  ;; Note that Spacemacs makes Emacs use the clipboard, so the following is
  ;; redundant:
  ;;(setq x-select-enable-clipboard t)
  ;;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

  ;; use spaces for indentation everywhere, with tab width = 4 spaces:
  ;;(setq-default indent-tabs-mode nil)
  ;;(setq tab-stop-list (number-sequence 4 200 4))
  ;; spacemacs does that already, see:
  ;; https://github.com/syl20bnr/spacemacs/issues/3037
  ;; https://github.com/syl20bnr/spacemacs/issues/3037#issuecomment-140473245

  ;; see matching pairs of parentheses and other characters.
  ;; When point is on one of the paired characters, the other is highlighted.
  ;;(show-paren-mode 1)
  ;;(setq show-paren-delay 0) ;; get rid of delay before showing match
  ;; spacemacs does that already

  ;; Activate fill column indicator in prog-mode and text-mode.
  (add-hook 'prog-mode-hook 'turn-on-fci-mode)
  (add-hook 'text-mode-hook 'turn-on-fci-mode)
  )
