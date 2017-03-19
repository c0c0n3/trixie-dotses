(defun spacefont (default)
  "Reads and evaluates the value of SPACEFONT, falling back to default if
 the variable isn't set or set to null/empty."
  (setq raw (getenv "SPACEFONT"))             ;; (1)
  (if (eq 0 (length raw)) default             ;; (2)
    (eval (car (read-from-string raw)))))     ;; (3)
;; NOTE
;; 1. getenv returns nil if the variable is not set and "" if set to null.
;; 2. length nil == 0; doesn't bomb out.
;; 3. Blindly trusting SPACEFONT to be set to a list in the same format
;; dotspacemacs-default-font expects. Yip kiss security goodbye, but why
;; make things more complicated when this is just for personal use?
;; More on evaluating strings here:
;; - http://emacs.stackexchange.com/questions/19877/how-to-evaluate-elisp-code-contained-in-a-string

;; Spacemacs variables configuration.
;; You should not put any user code in this function besides overriding the
;; Spacemacs variables you want to change from their defaults.
(defun theme/init ()
  (setq-default

   ;; Start off with Solarized dark. Hit 'M-m T n' to cycle to next theme.
   dotspacemacs-themes '(solarized-dark solarized-light
                         zenburn)

   ;; Default font. Tweak powerline-scale if separators don't look good.
   dotspacemacs-default-font (spacefont
                              '("Source Code Pro"
                               :size 18
                               :weight light
                               :width normal
                               :powerline-scale 1.1))
   )
  )

(defun theme/user-config ()
  ;; Fill column indicator style.
  (setq fci-rule-width 1)
  (setq fci-rule-color "#073642")  ;; Solarized Base02
  )
;; NOTE
;; 1. Hard-coded fill column indicator colour.
;; Any way I can avoid hard-coding it? Ideally it should be some constant
;; that is defined in both themes I'm using so that when switching themes
;; the colour is switched too.
