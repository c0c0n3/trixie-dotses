;; Spacemacs-based terminal emulator for use with an Emacs daemon.

;; Same config as terminal, but override term.el to make it work better
;; with the daemon.
(load-rel "../terminal/init.el")
(load-rel "term.el")
