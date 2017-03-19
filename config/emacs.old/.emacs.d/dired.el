;; when in Dired (C-x d) enable 'a' to visit directories
;; when using 'a' the directory buffer is reused instead of creating a new one for each
;; visited dir 
(put 'dired-find-alternate-file 'disabled nil)
