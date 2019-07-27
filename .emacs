(require 'org)
(setq-default user-emacs-directory "~/.config/emacs/")
(org-babel-load-file
 (expand-file-name "settings.org"
                   user-emacs-directory))
