;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.

(defun resolve-rel (file)
  "Resolves FILE relative to the path of the .el file where this resolve-rel
 function is called."
  (setq base-dir (file-name-directory load-file-name))
  (expand-file-name file base-dir))

(defun load-rel (file)
  "Loads an .el FILE given as a relative path to the .el file that defines
 this load-rel function."
  (load-file (resolve-rel file)))

(defun load-if (file)
  "Loads an .el FILE if it exists, does nothing otherwise."
  (if (file-exists-p file) (load-file file)))

(defun spaceconf ()
  "Reads the vaule of SPACECONF, falling back to 'editor' if the variable
 isn't set or set to null/empty."
  (setq raw (getenv "SPACECONF"))             ;; (1)
  (if (eq 0 (length raw)) "editor" raw))      ;; (2)
;; NOTE
;; 1. getenv returns nil if the variable is not set and "" if set to null.
;; 2. length nil == 0; doesn't bomb out.

(defun select-init ()
  "Determines the absolute path of the init.el file to load depending on
 SPACECONF, falling back to the editor config if SPACECONF is not set or
 set to rubbish."
  (setq init-path (resolve-rel (concat (spaceconf) "/init.el")))  ;; (1)
  (if (file-readable-p init-path) init-path
    (lwarn 'SPACECONF :error
           "can't access file: %S\nUsing editor config instead." init-path)
    (resolve-rel "editor/init.el")))
;; NOTE
;; 1. spaceconf is not "" at this point which is good otherwise you could
;; end up with a nasty infinite loop in your hands...

;; Use SPACECONF to figure out what config set to load.
(load (select-init))


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
