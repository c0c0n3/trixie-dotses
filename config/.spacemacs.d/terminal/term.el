(defun term/user-config ()
  (ansi-term "bash"))


;; Ctr+v to paste into terminal when in char mode.
(defun term-paste-hook ()
  (define-key term-raw-map (kbd "C-v") 'term-paste))
(add-hook 'term-mode-hook 'term-paste-hook)

;; NOTE
;; 1. UTF8. Spacemacs sets the buffer's process coding system to UTF8, which
;; is what I want.

;; Quit emacs when the shell exits.
;; This is similar to what 'multi-term.el' does but we quit emacs instead of
;; just killing the term buffer.
;; See:
;; - https://www.emacswiki.org/emacs/multi-term.el
;; - https://www.gnu.org/software/emacs/manual/html_node/elisp/Sentinels.html
;;
(advice-add 'term-sentinel :after #'maybe-quit-emacs)

(defun maybe-quit-emacs (process event)
  (when (memq (process-status process) '(signal exit))
        (kill-emacs-if-no-term-left)))

(defun is-term-buffer (buffer)
  (eq 'term-mode (with-current-buffer buffer major-mode)))

(defun list-term-buffers ()
  (cl-remove-if-not 'is-term-buffer (buffer-list)))

(defun has-active-terms ()
  (cl-some 'get-buffer-process (list-term-buffers)))

(defun kill-emacs-if-no-term-left ()
  (unless (has-active-terms) (save-buffers-kill-terminal)))
