;; code below was adapted from:
;; http://echosa.github.io/blog/2012/06/06/improving-ansi-term/

;; avoid ansi-term asking which shell to use
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)


;; Ctr+v to paste into terminal
(defun my-term-paste (&optional string)
  (interactive)
  (process-send-string 
   (get-buffer-process (current-buffer))
   (if string string (current-kill 0))))
(defun my-term-hook ()
  (define-key term-raw-map "\C-v" 'my-term-paste))
(add-hook 'term-mode-hook 'my-term-hook)


;; use UTF-8
(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)


;; quit emacs when the shell exits
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (save-buffers-kill-emacs))
    ad-do-it))
(ad-activate 'term-sentinel)

