(after! org
  (setq org-src-preserve-indentation nil))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil))

(setq treemacs-width 25)

(when (string= (system-name) "ruri")
  (setq doom-theme 'doom-outrun-electric)
  (setq doom-font (font-spec :family "IBM Plex Mono" :size 28 :weight 'semi-bold)
        doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 28)
        doom-big-font (font-spec :family "IBM Plex Mono" :size 40 :weight 'semi-bold)))

(when (string= (system-name) "nana")
  (setq doom-theme 'doom-dracula)
  (setq doom-font (font-spec :family "IBM Plex Mono" :size 16 :weight 'semi-bold)
        doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 16)
        doom-big-font (font-spec :family "IBM Plex Mono" :size 28 :weight 'semi-bold)))
