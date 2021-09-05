;; Spacemacs layers configuration.
;; See:
;; - https://develop.spacemacs.org/layers/LAYERS.html

;; Load custom layers function. If defined, we'll use it to override the
;; default layers below.
;; The function must be defined in a file named '.spacemacs.layers.el' in
;; your home, must be called 'custom-layers' and just return the list of
;; layers symbols as required by Spacemacs. Here's an example:
;;
;; (defun custom-layers ()
;;   '(auto-completion
;;     better-defaults
;;     emacs-lisp))
;;
(load-if "~/.spacemacs.layers.el")

(defun layers/defaults ()
  "Default Spacemacs layers to load."
  '(
    ;; checkers
    (spell-checking :variables
                    ispell-program-name "aspell"
                    ispell-dictionary "en_GB")
    syntax-checking

    ;; completion
    auto-completion
    helm

    ;; emacs
    better-defaults
    helpful

    ;; file trees
    (treemacs :variables   ;; see also navbar function below
              ;; don't scroll tree to focus currently visited file
              treemacs-use-follow-mode nil
              ;; highlight git file changes
              treemacs-use-git-mode 'simple)

    ;; programming languages
    emacs-lisp
    haskell
    latex
    markdown
    nixos

    ;; source control
    git
    version-control

    ;; tools
    (shell :variables
           shell-default-shell 'multi-term
           shell-default-height 30
           shell-default-position 'bottom)

    ))


(defun layers/list ()
  "List Spacemacs layers to load."
  (if (fboundp 'custom-layers) (custom-layers) (layers/defaults)))


(defun navbar ()
  "Bring up a Treemacs window with just a project for the current directory
and nothing else.
WARNING: it replaces all the projects in your current Treemacs workspace
with a project for the current directory.
"
  (interactive)
  (spacemacs/treemacs-project-toggle)
  (treemacs-project-follow-mode)
  (treemacs-display-current-project-exclusively)
  )
;; NOTE
;; Treemacs workspaces. They're very useful, check them out! Why this hack
;; then? To make it easy to start Emacs in the project root directory, then
;; hit `M-x navbar' to bring up the Treemacs window with just the project
;; directory in it as opposed to the default workspace and projects.
;; Read about workspaces as well as navigation without work spaces at:
;; - https://github.com/Alexander-Miller/treemacs
;; then have a look at the docs for `treemacs-project-follow-mode' and
;; `treemacs-display-current-project-exclusively', e.g.`M-x describe-symbol'
;; then enter `treemacs-project-follow-mode'.
;; Notice that `treemacs-display-current-project-exclusively' "will make the
;; current project the only project, all other projects *will be removed* from
;; the current workspace."
