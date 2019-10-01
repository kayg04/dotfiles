(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq package-enable-at-startup nil)
(setq package-archives
  '(("org"   . "https://orgmode.org/elpa/")
    ("gnu"   . "https://elpa.gnu.org/packages/")
    ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq
 use-package-verbose t
 use-package-always-ensure t)
(require 'use-package)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq
 delete-old-versions -1
 version-control t
 vc-make-backup-files t
 auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list" t)))

(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(setq
 savehist-file "~/.emacs.d/savehist"
 history-length t
 history-delete-duplicates t
 savehist-save-minibuffer-history 1
 savehist-additional-variables
 '(kill-ring
   search-ring
   regexp-search-ring))
(savehist-mode 1)

; (setenv "PATH" (concat (getenv "PATH") ":/home/kayg/.go/bin"))
(setq exec-path (append exec-path '("/home/kayg/.local/bin")))

(blink-cursor-mode 0)  ; Disable blinking cursor
(fringe-mode 0)        ; Disable fringes
(menu-bar-mode 0)      ; Disable menu bar
(scroll-bar-mode 0)    ; Disable scroll bar
(tool-bar-mode 0)      ; Disable toolbar
(tooltip-mode 0)       ; Disable tooltips

(setq-default
  ad-redefinition-action 'accept                ; Silence warnings for redefinition
  auto-window-vscroll nil                      ; Lighten vertical scroll
  confirm-kill-emacs 'yes-or-no-p              ; Confirm before exiting Emacs
  cursor-in-non-selected-windows t             ; Hide the curor in inactive windows
  delete-by-moving-to-trash t                  ; Delete files to trash
  display-line-numbers-type 'relative          ; Display relative line numbers
  display-time-default-load-average nil        ; Don't display load average
  display-time-format "%H:%M"                  ; Time format
  fill-column 60                               ; Set width for automatic line breaks
  help-window-select t                         ; Focus new help windows when opened
  indent-tabs-mode nil                         ; Stop using tabs to indent
  inhibit-startup-screen t                     ; Disable startup screen
  initial-scratch-message ""                   ; Initial scratch buffer should be empty
  left-margin-width 1                          ; Add left margin
  right-margin-width 1                         ; Add right margin
  scroll-conservatively most-positive-fixnum   ; Always scroll by one line
  scroll-margin 10                             ; Add a margin when scrolling vertically
  select-enable-clipboard t                    ; Merge system's and Emacs' clipboard
  sentence-end-double-space nil                ; End a sentence after a dot and a space
  show-trailing-whitespace t                   ; Show trailing whitespace
  show-paren-mode t                            ; Highlight matching parentheses
  tab-width 4                                  ; Set width for tabs
  uniquify-buffer-name-style 'forward          ; Set buffer name style for files that have same base folder
  window-combination-resize t                  ; Resize windows proportionally
  x-stretch-cursor t)                          ; Stretch cursor to the glypth width

(auto-fill-mode t)                            ; Wrap lines after fill-column value
(cd "~/")                                     ; Move to the user's home directory
(delete-selection-mode t)                     ; Replace region when inserting text
(fset 'yes-or-no-p 'y-or-n-p)                 ; Replace yes / no with y / n
(global-display-line-numbers-mode t)          ; Enable line numbers globally
(global-subword-mode t)                       ; Iterate through CamelCase ('GtkWindow', 'MyQueen', etc) words
(global-visual-line-mode t)                   ; Word wrap at visual lines instead of logical lines
(mouse-avoidance-mode 'banish)                ; Avoid collision of mouse with point
(set-default-coding-systems 'utf-8)           ; Defaults to utf-8 encoding
(show-paren-mode t)                           ; Show matching parentheses

(setq gc-cons-threshold 200000000)

(use-package esup)

(setq remote-file-name-inhibit-cache nil)
(setq vc-ignore-dir-regexp
      (format "%s\\|%s"
                    vc-ignore-dir-regexp
                    tramp-file-name-regexp))
(setq tramp-verbose 1)

(use-package company
  :defer t
  :hook
  (after-init . global-company-mode))

(use-package lsp-mode
  :defer t
  :commands lsp)

(use-package lsp-ui
  :defer t
  :commands lsp-ui-mode
  :config
  (setq-default lsp-ui-doc-max-height 100)
  (setq-default lsp-ui-doc-max-width 100))

(use-package company-lsp
  :defer t
  :after company-mode
  :commands company-lsp
  :init
  (setq-default company-lsp-cache-candidates 'auto)    ; Cache completions only if they are complete
  (setq-default company-lsp-async t)                   ; Fetch results asynchronously
  (setq-default company-lsp-enable-snippet t)          ; Expand snippet upon completion
  (setq-default company-lsp-enable-recompletion t))    ; Enable recompletion

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-responsive 'stack))

(use-package caddyfile-mode)

(use-package go-mode)

(use-package ob-go)

(use-package ini-mode)

(use-package lsp-java)

(use-package json-mode)

(use-package lua-mode)

(use-package nginx-mode)
(use-package company-nginx)

(use-package nix-mode)

(use-package nixos-options)
(use-package helm-nixos-options)
(use-package company-nixos-options
  :config
  (add-to-list 'company-backends 'company-nixos-options))
(use-package nix-sandbox)

(use-package toml-mode)

(use-package yaml-mode)

(use-package flycheck
  :defer t
  :hook (prog-mode . flycheck-mode)
  :config
  (add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.25))))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :hook (prog-mode . electric-pair-mode)
  :config
  (require 'smartparens-config))

(use-package general
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"

  ;; LEADER + any of the following keys results in calling
  ;; the function specified. The general combination is
  ;; binding a mnemonic keyword, preserving vim's sane
  ;; choice of keybindings.

  ;; Buffers
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "bl"  '(list-buffers :which-key "list buffers")
  "bq"  '(kill-buffer :which-key "kill buffer")
  "bw"  '(save-buffer :which-key "save buffer")
  "bs"  '(switch-to-buffer :which-key "switch buffer")

  ;; Evil Mode
  "ei"  '(evil-edit /home/yozu/Productivity/GitLab/nix-home/emacs/settings.org :which-key "edit emacs init")
  "ew"  '(evil-save :which-key "save current buffer")
  "eW"  '(evil-save-and-close :which-key "save current buffer and close window")
  "eq"  '(evil-quit :which-key "close current window")
  "eQ"  '(evil-save-and-quit :which-key "save all buffers and exit Emacs")

  ;; FlyCheck
  "fe"  '(flycheck-explain-error-at-point :which-key "explain error at point")
  "fl"  '(flycheck-list-errors :which-key "list all errors")
  "fn"  '(flycheck-next-error :which-key "show next error")
  "fp"  '(flycheck-previous-error :which-key "show previous error")

  ;; Helm-specific
  "SPC" '(helm-M-x :which-key "M-x")
  "hf"  '(helm-find-files :which-key "find files")
  "hb"  '(helm-buffers-list :which-key "buffers list")
  "ho"  '(helm-occur :which-key "occurences")
  "ha"  '(helm-apropos :which-key "info about everything")
  "ho"  '(helm-info-emacs :which-key "info about emacs")
  "hw"  '(helm-world-time :which-key "world time")
  "hn"  '(helm-nixos-options :which-key "display NixOS options")

  ;; Magit
  "ms"  '(magit-status :which-key "display git status")

  ;; Org
  "ow"  '(widen :which-key "expand focus to the whole buffer")
  "on"  '(org-narrow-to-subtree :which-key "narrow focus to current subtree")

  ;; Shells
  "st"  '(vterm :which-key "open vterm")
  "se"  '(eshell :which-key "open emacs shell")

  ;; Sudo
  "su"  '(sudo-edit :which-key "open file with sudo")

  ;; Native windows
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wx"  '(delete-window :which-key "delete window")
  ;; Centaur Tabs
  "tn"  '(centaur-tabs-forward :which-key "open next tab")
  "tp"  '(centaur-tabs-backward :which-key "open previous tab")
  ;; Workspaces
  "wr"  '(eyebrowse-rename-window-config :which-key "rename workspace")
))

(global-set-key (kbd "M-r") 'eyebrowse-rename-window-config)

(use-package evil
  :init
  (setq evil-shift-width 4)    ; Number of columns to shift with > and <
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t))

(use-package evil-escape
  :after evil
  :init
  (setq-default evil-escape-key-sequence "jk")          ; Enter Normal mode when jk is pressed
  (setq-default evil-escape-unordered-key-sequence t)   ; in any order
  :config
  (evil-escape-mode t))

(use-package evil-collection
  :after evil
  :custom (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-magit
  :config
  (setq evil-magit-use-y-for-yank t)    ;; Disable visual mode in magit buffers
  (setq evil-magit-state 'normal))       ;; Start Magit buffers in this mode

(org-babel-do-load-languages 'org-babel-load-languages
                             '((emacs-lisp . t)
                               (shell . t)
                               (python . t)
                               (go . t)))

(add-hook 'org-mode-hook #'org-indent-mode)
(add-hook 'org-mode-hook #'flyspell-mode)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"))                ;; personal snippets
  (push yasnippet-snippets-dir yas-snippet-dirs)
  (yas-global-mode))

(use-package yasnippet-snippets)

(use-package fringe-helper)
(use-package git-gutter-fringe
    :config
    (global-git-gutter-mode)
    (set-face-foreground 'git-gutter-fr:modified "yellow")
    (set-face-foreground 'git-gutter-fr:added    "green")
    (set-face-foreground 'git-gutter-fr:deleted  "red")
    (setq-default left-fringe-width  10)
    (setq-default right-fringe-width 10)
    (setq git-gutter-fr:side 'left-fringe))

(use-package all-the-icons
  :config
  (setq inhibit-compacting-font-caches t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :hook
    (after-init . doom-modeline-mode)
  :config
    ;; How tall the mode-line should be. It's only respected in GUI.
    ;; If the actual char height is larger, it respects the actual height.
    (setq doom-modeline-height 20)

    ;; How wide the mode-line bar should be. It's only respected in GUI.
    (setq doom-modeline-bar-width 3)

    ;; Determines the style used by `doom-modeline-buffer-file-name'.
    ;;
    ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
    ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
    ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
    ;;   truncate-with-project => emacs/l/comint.el
    ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
    ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
    ;;   truncate-all => ~/P/F/e/l/comint.el
    ;;   relative-from-project => emacs/lisp/comint.el
    ;;   relative-to-project => lisp/comint.el
    ;;   file-name => comint.el
    ;;   buffer-name => comint.el<2> (uniquify buffer name)
    ;;
    ;; If you are expereicing the laggy issue, especially while editing remote files
    ;; with tramp, please try `file-name' style.
    ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
    (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

    ;; Whether display icons in mode-line or not.
    (setq doom-modeline-icon t)

    ;; Whether display the icon for major mode. It respects `doom-modeline-icon'.
    (setq doom-modeline-major-mode-icon t)

    ;; Whether display color icons for `major-mode'. It respects
    ;; `doom-modeline-icon' and `all-the-icons-color-icons'.
    (setq doom-modeline-major-mode-color-icon t)

    ;; Whether display icons for buffer states. It respects `doom-modeline-icon'.
    (setq doom-modeline-buffer-state-icon t)

    ;; Whether display buffer modification icon. It respects `doom-modeline-icon'
    ;; and `doom-modeline-buffer-state-icon'.
    (setq doom-modeline-buffer-modification-icon t)

    ;; Whether display minor modes in mode-line or not.
    (setq doom-modeline-minor-modes nil)

    ;; If non-nil, a word count will be added to the selection-info modeline segment.
    (setq doom-modeline-enable-word-count nil)

    ;; Whether display buffer encoding.
    (setq doom-modeline-buffer-encoding t)

    ;; Whether display indentation information.
    (setq doom-modeline-indent-info t)

    ;; If non-nil, only display one number for checker information if applicable.
    (setq doom-modeline-checker-simple-format t)

    ;; The maximum displayed length of the branch name of version control.
    (setq doom-modeline-vcs-max-length 12)

    ;; Whether display perspective name or not. Non-nil to display in mode-line.
    (setq doom-modeline-persp-name nil)

    ;; Whether display `lsp' state or not. Non-nil to display in mode-line.
    (setq doom-modeline-lsp t)

    ;; Whether display github notifications or not. Requires `ghub` package.
    (setq doom-modeline-github nil)

    ;; The interval of checking github.
    ;; (setq doom-modeline-github-interval (* 30 60))

    ;; Whether display environment version or not
    (setq doom-modeline-env-version t)
    ;; Or for individual languages
    (setq doom-modeline-env-enable-python t)
    (setq doom-modeline-env-enable-ruby nil)
    (setq doom-modeline-env-enable-perl nil)
    (setq doom-modeline-env-enable-go t)
    (setq doom-modeline-env-enable-elixir nil)
    (setq doom-modeline-env-enable-rust nil)

    ;; Change the executables to use for the language version string
    (setq doom-modeline-env-python-executable "python")
    (setq doom-modeline-env-ruby-executable "ruby")
    (setq doom-modeline-env-perl-executable "perl")
    (setq doom-modeline-env-go-executable "go")
    (setq doom-modeline-env-elixir-executable "iex")
    (setq doom-modeline-env-rust-executable "rustc")

    ;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
    (setq doom-modeline-mu4e nil)

    ;; Whether display irc notifications or not. Requires `circe' package.
    (setq doom-modeline-irc nil)

    ;; Function to stylize the irc buffer names.
    ;; (setq doom-modeline-irc-stylize 'identity)
    )

(add-hook 'org-mode-hook (lambda ()
   "Beautify Org Checkbox Symbol"
   (push '("[ ]" . "☐") prettify-symbols-alist)
   (push '("[X]" . "☑" ) prettify-symbols-alist)
   (push '("[-]" . "❍" ) prettify-symbols-alist)
   (prettify-symbols-mode)))

(use-package doom-themes
  :config
    ;; Available themes: https://github.com/hlissner/emacs-doom-themes
    ;; Global settings (defaults)
    (setq doom-themes-enable-bold t)    ; if nil, bold is universally disabled
    (setq doom-themes-enable-italic t)   ; if nil, italics is universally disabled

    ;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
    ;; may have their own settings.
    ;; (load-theme 'doom-one t)

    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)

    ;; Enable custom neotree theme (all-the-icons must be installed!)
    ;; (doom-themes-neotree-config)
    ;; or for treemacs users
    ;; (doom-themes-treemacs-config)

    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))

(load-theme 'doom-dracula t)

(use-package kaolin-themes)
;;  :config
;;  (kaolin-treemacs-theme))

(use-package helm
  :config
  (helm-mode t))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  ;; Open Dashboard on `emacsclient -c`
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  ;; Set the title
  (setq dashboard-banner-logo-title "Welcome to the Lisp Machine!")
  ;; Set the banner
  (setq dashboard-startup-banner 3)
  ;; Value can be
  ;; 'official which displays the official emacs logo
  ;; 'logo which displays an alternative emacs logo
  ;; 1, 2 or 3 which displays one of the text banners
  ;; "path/to/your/image.png" which displays whatever image you would prefer

  ;; Content is not centered by default. To center, set
  (setq dashboard-center-content t)

  ;; To disable shortcut "jump" indicators for each section, set
  (setq dashboard-show-shortcuts t))

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode))
  ;; If you have use-package-hook-name-suffix set to nil, uncomment and use the
  ;; line below instead:
  ; :hook (eshell-mode-hook . esh-autosuggest-mode)

(use-package magit
  :defer t)

(use-package page-break-lines
  :config
  (global-page-break-lines-mode))

(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  (which-key-mode))

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "slant")
  (setq centaur-tabs-set-close-button nil)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-height 40))

(use-package vterm)

(use-package eyebrowse
  :hook
  (after-init . eyebrowse-mode)
  :config
  (setq eyebrowse-new-workspace t)
  (eyebrowse-setup-opinionated-keys))
