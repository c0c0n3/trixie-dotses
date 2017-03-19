;; Spacemacs user's configuration.
;; This is the place where most of your configurations should be done.
(defun speedbar/user-config ()
  ;; Show all files when in the speedbar.
  ;; In addition to show-unknown-files, you also have to set the unshown-regexp
  ;; as below to really show everything, even dot files. See:
  ;; - http://stackoverflow.com/questions/5135209/show-hidden-files-in-speedbar
  (setq speedbar-show-unknown-files t)
  (setq speedbar-directory-unshown-regexp "^$")

  ;; Get rid of ugly speedbar icons: use '+', '-', '?', etc. instead of icons.
  (setq speedbar-use-images nil)
  )
