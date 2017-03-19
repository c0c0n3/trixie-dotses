;; disable menu and toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; make the frame transparent
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(85 85))
(add-to-list 'default-frame-alist '(alpha 85 85))
