(require 'org)
(setq-default user-emacs-directory "~/.config/emacs/")
(setq-default package-user-dir "~/.config/emacs/pkgs")
(setq-default backup-directory-alist "~/.config/emacs/backups")
(org-babel-load-file
 (expand-file-name "settings.org"
                   user-emacs-directory))
