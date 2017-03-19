(defun term/user-config ()
  ;; Overriding this from terminal/term so that the daemon doesn't start a
  ;; terminal; we let the client do that instead with e.g.
  ;;
  ;;     emacsclient -c -e '(ansi-term "bash")'
  )
;; NOTE
;; Spacemacs startup buffer. The hook I have in terminal/frame works for
;; the standalone terminal but for some reason doesn't in the daemon.
;; So the first time you connect to the daemon with the above command,
;; you'll see the Spacemacs buffer just before the terminal. This won't
;; happen the second time around, but the Spacemacs buffer is still there.
;; Not sure how to get rid of it for good.

(defun remove-if-dead (buffer)
  (unless (get-buffer-process buffer) (kill-buffer buffer)))

;; Overriding this from terminal/term so that we kill the client frame
;; unconditionally when the terminal exits. In fact, there may be other
;; active terms in the daemon, so we shouldn't check for that as killing
;; the client frame doesn't kill any of those other terms. But the term
;; that is exiting leaves behind a dead buffer in the daemon, so we clean
;; that up to avoid it showing in the buffers list.
(defun kill-emacs-if-no-term-left ()
  (mapcar 'remove-if-dead (list-term-buffers))
  (save-buffers-kill-terminal))
