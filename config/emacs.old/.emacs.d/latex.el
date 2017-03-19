;; Enable Printing package
(require 'printing)
(pr-update-menus t)

;; M-x print-to-pdf: print the current buffer to a pdf file in the same directory.
;; Alternatively, you can do this manually with C-u M-x ps-spool-buffer-with-faces
;; to print to PostScript (you'll be prompted for a file name) and then use ps2pdf
;; to turn it into a PDF.
;; (Note that M-x ps-spool-buffer-with-faces generates the PostScript in a new
;; buffer.)
(defun print-to-pdf ()
  (interactive)
  (ps-spool-buffer-with-faces)
  (switch-to-buffer "*PostScript*")
  (write-file "/tmp/tmp.ps")
  (kill-buffer "tmp.ps")
  (setq cmd (concat "ps2pdf /tmp/tmp.ps " (buffer-name) ".pdf"))
  (shell-command cmd)
  (shell-command "rm /tmp/tmp.ps")
  (message (concat "Saved to:  " (buffer-name) ".pdf"))
)

;; Auctex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

(setq-default TeX-master nil) ; Query for master file.
(setq TeX-PDF-mode t)  ;; set pdflatex default, not latex

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)  ;; integrate RefTeX
(setq reftex-plug-into-AUCTeX t)             ;; into AucTeX
