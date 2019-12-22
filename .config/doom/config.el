(setq doom-theme 'doom-outrun-electric)

(after! org
  (setq org-src-preserve-indentation nil))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil))

(setq treemacs-width 25)

(setq doom-font (font-spec :family "IBM Plex Mono" :size 26 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
      doom-unicode-font (font-spec :family "Input Mono Narrow" :size 26)
      doom-big-font (font-spec :family "IBM Plex Mono" :size 40 :weight 'semi-bold))
