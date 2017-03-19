;; Spacemacs user's configuration.
;; This is the place where most of your configurations should be done.
(defun shell/user-config ()
  ;; Display colourised shell output.
  ;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  ;;(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

  ;; Make shell buffer editable.
  ;; See:
  ;; - http://emacs.stackexchange.com/questions/2883/any-way-to-make-prompts-and-previous-output-uneditable-in-shell-term-mode
  (setq comint-prompt-read-only nil)
  )


;; NOTE
;; 1. UTF8. Spacemacs sets the buffer's process coding system to UTF8, which
;; is what I want.
;; 2. Colours. Enabling ANSI color doesn't seem to have any effect in Shell.
;; Some colourisation happens anyway, but doesn't work for e.g. ls, grep, etc.
;; Note that Ansi-Term and Multi-Term both colourise the output even without
;; these settings.
