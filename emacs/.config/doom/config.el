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

(after! ivy
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center))
        ivy-posframe-height-alist '((t . 10)))
  (if (member "Iosevka" (font-family-list))
      (setq ivy-posframe-parameters '((internal-border-width . 12) (font . "Iosevka")))
    ivy-posframe-parameters '((internal-border-width . 12)))
  (setq ivy-posframe-width 100)
  (ivy-posframe-mode +1))

;; Font changes
(defface my-prog-mode-default-face
  '((t (:inherit default :family "Iosevka")))
  "Programming Mode Default Face")

(add-hook 'lsp-ui-doc-frame-hook
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "IBM Plex Sans" :height 120)))

(add-hook! 'prog-mode-hook
  (face-remap-add-relative 'default 'my-prog-mode-default-face))

(custom-theme-set-faces
  'user
  '(org-block ((t (:inherit default :family "Iosevka"))))
  '(org-code ((t (:inherit default :family "Iosevka")))))

(setq +doom-dashboard-banner-file "/home/kayg/Downloads/banner.jpg")
(setq +doom-dashboard-banner-padding '(1 . 2))
(setq centaur-tabs-gray-out-icons t)
(setq centaur-tabs-height 60)
(setq centaur-tabs-set-bar 'over)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-style "box")
(setq company-idle-delay 0)
(setq evil-escape-unordered-key-sequence t)
(setq treemacs-width 25)

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
