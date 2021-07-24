(after! org
  (setq org-src-preserve-indentation nil)
  (setq org-log-done t)
  (setq org-agenda-files '("~/Notes/Personal/Agenda.org"))
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
  (setq ivy-posframe-width 100)
  (ivy-posframe-mode +1))

;; set relative line numbers in all modes
(setq display-line-numbers-type 'relative)

;; set mixed-pitch in text modes, disable line numbers totally
(add-hook! 'org-mode-hook
  (mixed-pitch-mode 1)
  (setq display-line-numbers-type nil))

(setq +doom-dashboard-banner-file "~/.config/doom/banner.jpg")
(setq +doom-dashboard-banner-padding '(2 . 3))
(setq centaur-tabs-gray-out-icons t)
(setq centaur-tabs-height 60)
(setq centaur-tabs-set-bar 'over)
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-style "box")
(setq company-idle-delay 0)
(setq evil-escape-unordered-key-sequence t)
(setq treemacs-width 25)

;; transparency
(defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 70) '(100 . 100)))))

; Turn off hard-wrapping of lines
(turn-off-auto-fill)
; Use soft-wrapping instead
(+global-word-wrap-mode 1)

;; ePUB documents
(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

;; if emacs is running in a graphical window, use outrun electric
;; otherwise use doom-laserwave
(if (display-graphic-p)
    (setq doom-theme 'doom-outrun-electric)
    (setq doom-outrun-electric-comment-bg t)
  (setq doom-theme 'doom-laserwave))

;; use padding for the modeline in themes that support it
(setq doom-themes-padded-modeline t)

;; laptop
(when (string= (system-name) "ruri")
  (setq doom-font (font-spec :family "Cascadia Code PL" :size 34 :weight 'semi-bold)
        doom-variable-pitch-font (font-spec :family "Source Sans Pro" :size 36 :weight 'semi-bold)
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 34)
        doom-big-font (font-spec :family "Cascadia Code PL" :size 48 :weight 'bold)))

;; VM or WSL2
(when (or (string= (system-name) "btwiusearch")
          (string= (system-name) "nana"))
  (setq doom-font (font-spec :family "Cascadia Code PL" :size 34 :weight 'regular)
        doom-variable-pitch-font (font-spec :family "Lexend Deca" :size 36 :weight 'semi-bold)
        doom-unicode-font (font-spec :family "Input Mono Narrow" :size 34)
        doom-big-font (font-spec :family "Cascadia Code PL" :size 48 :weight 'semi-bold)))
