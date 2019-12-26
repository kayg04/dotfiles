(after! org
  (setq org-src-preserve-indentation nil)
  (setq org-hide-emphasis-markers t))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-max-height 6)
  (setq lsp-ui-doc-max-width 54))

;; Font changes
(add-hook 'lsp-ui-doc-frame-hook
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "Fira Mono" :height 132)))

(defface my-prog-mode-default-face
  '((t (:inherit default :family "Iosevka")))
  "Programming Mode Default Face")
(add-hook! 'prog-mode-hook (face-remap-add-relative 'default 'my-prog-mode-default-face))

(setq treemacs-width 25)
(setq evil-escape-unordered-key-sequence t)

(when (string= (system-name) "ruri")
  (setq doom-theme 'doom-outrun-electric)
  (setq doom-outrun-electric-comment-bg t)
  (setq doom-font (font-spec :family "IBM Plex Mono" :size 28 :weight 'semi-bold)
        doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 26 :weight 'semi-bold)
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 28)
        doom-big-font (font-spec :family "IBM Plex Mono" :size 44 :weight 'bold)))

(when (string= (system-name) "nana")
  (setq doom-theme 'doom-dracula)
  (setq doom-font (font-spec :family "SF Mono" :size 20 :weight 'semi-bold)
        doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 18 :weight 'semi-bold)
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 20)
        doom-big-font (font-spec :family "SF Mono" :size 36 :weight 'semi-bold)))
