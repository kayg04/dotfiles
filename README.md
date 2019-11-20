
# Table of Contents

1.  [Bootstrap](#orgd06a628)
2.  [Autostart](#orgb8f71ea)
    1.  [Scripts](#orga189080)
        1.  [SSH](#org422d82d)
3.  [Desktop](#org112cd1d)
    1.  [Invidious](#orgba552f0)
    2.  [Riot](#org754b0f1)
    3.  [Slack](#org25e9014)
    4.  [Wire](#orgf16e3ef)
4.  [Emacs](#orge7b7ccd)
    1.  [Init](#orgd5790b0)
    2.  [Config](#org19b14aa)
    3.  [Packages](#org5259f8a)
5.  [Firefox](#org16b0fce)
    1.  [Profiles](#orgc9ae31c)
    2.  [Policies](#org56ac293)
    3.  [UserJS](#org6573191)
        1.  [General](#org1835e4a)
        2.  [Themes](#org0f669d7)
    4.  [Setup](#org6577c7b)
6.  [Plasma](#org6287c93)
    1.  [Environment](#org29a6636)
    2.  [PAM](#org4e14a43)
7.  [Systemd](#org1d0b8dd)
    1.  [SSH Agent](#org16a9c34)
8.  [Thunderbird](#orga83c2c6)
    1.  [Profiles](#org2af266c)
9.  [Ungoogled Chromium](#org3fa7f77)
    1.  [Environment Variables](#org10f81c9)
    2.  [Flags](#orgf369b9a)
10. [Scripts](#org0c2dae8)
    1.  [General](#orgecf11a3)
        1.  [Ungoogled Chromium Extension Updater](#org294df96)
        2.  [Wallpaper Index](#orgd4bd480)
    2.  [Helpers](#orgfcb4f25):documentation:
        1.  [Bash Sanity](#orgbfa5796)
        2.  [Run Script](#orgb20bd43)
        3.  [Fetch Source](#orgababe62)
        4.  [Cleanup](#orge78f1b7)
    3.  [Plasma](#orgff782cd)
        1.  [Virtual Desktop Bar (KDE)](#org66e38c5)
        2.  [KWin Tiling Script (Faho)](#org9baed8c)
    4.  [Spotify](#org0c5abc6):documentation:
        1.  [WM Name](#orgef44454)
        2.  [Lyrics](#org9c39fbe)
        3.  [Theme](#orga43238d)
11. [ZSH](#orgafcd288)
    1.  [Oh-my-zsh stuff](#org671b6ab)
    2.  [Functions](#org0a8b1d7)
        1.  [Weather](#org540dabc)
    3.  [Variables](#orge96e996)
    4.  [Aliases](#orgbc9763e)
    5.  [Source](#org42edea4)



<a id="orgd06a628"></a>

# Bootstrap

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    ZSH="${HOME}/.config/omz"
    ZSH_CUSTOM="${HOME}/.config/omz/custom"
    
    update() {
        case "${1}" in
            "desktop")
                updateDesktop
                ;;
            "doom"|"emacs")
                updateEmacs
                ;;
            "firefox")
                updateFirefox
                ;;
            "plasma")
                updatePlasma
                ;;
            "spotify")
                updateSpotify
                ;;
            "systemd")
                updateSystemd
                ;;
            "thunderbird")
                updateThunderbird
                ;;
            "chromium")
                updateChromium
                ;;
            "utilsh")
                updateUtilsh
                ;;
            "zsh")
                updateZSH
                ;;
        esac
    }
    
    updateDesktop() {
        ln -sf "${SCRIPT_PATH}"/.local/share/applications/*.desktop "${HOME}"/.local/share/applications/
    }
    
    updateEmacs() {
        ln -sf "${SCRIPT_PATH}"/.config/doom/* "${HOME}"/.config/doom/
        "${HOME}"/.emacs.d/bin/doom refresh
    }
    
    updateFirefox() {
        source "${SCRIPT_PATH}"/.mozilla/firefox/bootstrap.sh
    
        applyPolicies
        applyProfilesINI
        updateUserJS
        applyUserJS
        cleanUp
    }
    
    updatePlasma() {
        ln -sf "${SCRIPT_PATH}"/.config/autostart-scripts/*.sh "${HOME}"/.config/autostart-scripts/
        ln -sf "${SCRIPT_PATH}"/.config/plasma-workspace/env/*.sh "${HOME}"/.config/plasma-workspace/env/
        ln -sf "${SCRIPT_PATH}"/.pam_environment "${HOME}"/
    }
    
    updateSystemd() {
        ln -sf "${SCRIPT_PATH}"/.config/systemd/user/*.service "${HOME}"/.config/systemd/user/
    
        for service in $(ls -1 "${HOME}/.config/systemd/user" | cut -d '.' -f1); do
            systemctl --user enable --now "${service}"
        done
    }
    
    updateThunderbird() {
        ln -sf "${SCRIPT_PATH}"/.thunderbird/profiles.ini "${HOME}"/.thunderbird/
    }
    
    updateVSCodium() {
        ln -sf "${SCRIPT_PATH}"/.config/VSCodium/User/*.json "${HOME}"/.config/VSCodium/User/
    }
    
    updateChromium() {
        ln -sf "${SCRIPT_PATH}"/.config/chromium-flags.conf "${HOME}"/.config/
    }
    
    updateUtilsh() {
        ln -sf "${SCRIPT_PATH}"/.local/bin/* "${HOME}"/.local/bin/
    }
    
    updateZSH() {
        if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting ]]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
        fi
    
        if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions ]]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
        fi
    
        ln -sf "${SCRIPT_PATH}"/.zshrc "${HOME}"/
    }
    
    setup() {
        case "${1}" in
            "desktop")
                setupDesktop
                ;;
            "doom"|"emacs")
                setupEmacs
                ;;
            "firefox")
                setupFirefox
                ;;
            "plasma")
                setupPlasma
                ;;
            "spotify")
                setupSpotify
                ;;
            "systemd")
                setupSystemd
                ;;
            "thunderbird")
                setupThunderbird
                ;;
            "chromium")
                setupChromium
                ;;
            "utilsh")
                setupUtilsh
                ;;
            "zsh")
                setupZSH
                ;;
        esac
    }
    
    setupDesktop() {
        mkdir -p "${HOME}"/.local/share/applications
        updateDesktop
    }
    
    setupEmacs() {
        echo -e "Creating doom emacs directory..."
        if mkdir -p "${HOME}"/.config/doom; then
            printf '\u2714\n'
        else
            printf '\u274c\n'
        fi
    
        echo -ne "Cloning doom emacs source..."
        if git clone https://github.com/hlissner/doom-emacs ~/.emacs.d; then
            printf '\u2714\n'
        else
            printf '\u274c\n'
        fi
    
        echo -e "Unleashing doom..."
        "${HOME}"/.emacs.d/bin/doom install
    
        updateEmacs
    }
    
    setupFirefox() {
        source "${SCRIPT_PATH}"/.mozilla/firefox/bootstrap.sh
    
        applyPolicies
        createProfilesINIDir
        applyProfilesINI
        createProfiles
        updateUserJS
        applyUserJS
        cleanUp
        startFirefox
    }
    
    setupPlasma() {
        updatePlasma
    }
    
    setupSpotify() {
        source "${SCRIPT_PATH}"/.config/spotify/wmname.sh
    
        # fix wm name setting
        fetchSource
        buildLibrary
        moveLibrary
        fixSpotify
    }
    
    setupSystemd() {
        mkdir -p "${HOME}/.config/systemd/user"
    }
    
    setupThunderbird() {
        mkdir -p "${HOME}"/.config/thunderbird/primary
        updateThunderbird
    }
    
    setupVSCodium() {
        updateVSCodium
    }
    
    setupChromium() {
        updateChromium
    }
    
    setupUtilsh() {
        updateUtilsh
    }
    
    setupZSH() {
        if [[ ! upgrade_oh_my_zsh || ! -d "${HOME}/.oh-my-zsh" ]]; then
            export ZSH="${HOME}/.config/omz"
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        else
            exit 1
        fi
    }
    
    addToPath() {
        echo -e "Adding this program to \$PATH so that it is globally available."
        mkdir -p "${HOME}"/.local/bin
        ln -sf "${SCRIPT_PATH}"/dot "${HOME}"/.local/bin/
    }
    
    refresh() {
        git --git-dir="${SCRIPT_PATH}/.git" --work-tree="${SCRIPT_PATH}" pull
    }
    
    main() {
        case "${1}" in
            "setup")
                setup "${2}"
                ;;
            "update")
                update "${2}"
                ;;
            "set")
                addToPath
                ;;
            "refresh")
                refresh
                ;;
            *)
                echo -e "Invalid option."
                ;;
        esac
    }
    
    main "${@}"


<a id="orgb8f71ea"></a>

# Autostart


<a id="orga189080"></a>

## Scripts


<a id="org422d82d"></a>

### SSH

    # Enable extended globbing
    shopt -s extglob dotglob nullglob
    
    # Add all files in $HOME/.ssh/keys that do not end
    # with .pub
    ssh-add "${HOME}"/.ssh/keys/!(*.pub) </dev/null


<a id="org112cd1d"></a>

# Desktop


<a id="orgba552f0"></a>

## Invidious

    [Desktop Entry]
    Name=Invidious
    StartupNotify=true
    Icon=/home/kayg/Pictures/Icons/youtube.png
    Comment=Most popular video streaming platform
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://tube.kayg.org/
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/youtube;
    StartupWMClass=invidious
    Categories=Audio;Music;Player;AudioVideo;


<a id="org754b0f1"></a>

## Riot

    [Desktop Entry]
    Name=Riot
    Comment=A feature-rich client for Matrix.org
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://riot.im/app/
    Terminal=false
    Type=Application
    Icon=/home/kayg/Pictures/Icons/riot.png
    StartupWMClass="Riot"
    Categories=Network;InstantMessaging;Chat;IRCClient


<a id="org25e9014"></a>

## Slack

    [Desktop Entry]
    Name=Slack
    StartupWMClass=Slack
    Comment=Where work happens
    GenericName=Slack Desktop
    Exec=chromium --user-data-dir=${HOME}/.config/chromium/Apps --app=https://iiit-bhcoding.slack.com/
    Icon=slack
    Terminal=false
    Type=Application
    MimeType=x-scheme-handler/slack;
    StartupNotify=true
    Categories=GNOME;GTK;Network;InstantMessaging;


<a id="orgf16e3ef"></a>

## Wire

    [Desktop Entry]
    Name=Wire
    Comment=The most secure collaboration platform.
    Exec=chromium --user-data-dir=$HOME/.config/chromium/Apps --app=https://app.wire.com
    Terminal=false
    Type=Application
    Icon=/home/kayg/Pictures/Icons/wire.png
    StartupWMClass=Wire
    Categories=Network;
    GenericName=Secure messenger
    Keywords=chat;encrypt;e2e;messenger;videocall
    MimeType=x-scheme-handler/wire
    Version=1.1


<a id="orge7b7ccd"></a>

# Emacs

After an year of configuring Emacs, I have somehow reached
exactly at a point which mimics the style and philosophy of
Doom Emacs without realizing it. Although my configuration
was, at heart, a doomacs; in performance and functionality,
it lagged behind by a significant margin.

I have found myself frustrated by the fact that I have to
bake in functionality of every kind when I&rsquo;m in *need* of
that particular functionality, and hence, a lot of time was
spent in adding functionality rather than being creative or
productive. My first train of thought was to try something
which abstracted all of this functionality into a single
click &#x2013; something like VSCodium &#x2013; but the problem with
that particular editor is it isn&rsquo;t particularly hackable.
Apart from a hundred or so rants about how lacking VSCodium
is to my pal [Anwes](https://pandacowbat.com), one particular thing that irked me a lot
was the incessant need to reach for the mouse for something
or the other. I would have to change the whole keyboard
shortcuts layout to customize it to my needs and what was
worse is that I would have to remember two of those layouts
&#x2013; one which worked with the vim emulation and one which
worked with native VSCodium &#x2013; and the latter doesn&rsquo;t even
support three key chord bindings at the time of writing
this.

What VSCodium excels at, though, is the autocompletion,
intellisense, *almost* baked-in like support for linting,
checking, debugging. LSP is a first class citizen in
VSCodium and VSCodium is the first (and perhaps the only?)
editor that LSP is tested on. All of this makes LSP on
something like Emacs a slow, tedious hog; adding further
disappointment given the time taken to configure it.

The solution &#x2013; or perhaps &#x2013; the best balance that I could
find was in ****doom**** (pun intended). Doom Emacs (for now, at
least) seems to do everything I need, OOTB; has a
trouble-free way of adding language support. So I am
throwing away (or refactoring?) my 1 year-in-the-making
configuration of Emacs to find my peace in doom.


<a id="orgd5790b0"></a>

## Init

    ;;; init.el -*- lexical-binding: t; -*-
    
    ;; Copy this file to ~/.doom.d/init.el or ~/.config/doom/init.el ('doom install'
    ;; will do this for you). The `doom!' block below controls what modules are
    ;; enabled and in what order they will be loaded. Remember to run 'doom refresh'
    ;; after modifying it.
    ;;
    ;; More information about these modules (and what flags they support) can be
    ;; found in modules/README.org.
    
    (doom! :input
           ;;chinese
           ;;japanese
    
           :completion
           company           ; the ultimate code completion backend
           ;;helm              ; the *other* search engine for love and life
           ;;ido               ; the other *other* search engine...
           ivy               ; a search engine for love and life
    
           :ui
           ;;deft              ; notational velocity for Emacs
           doom              ; what makes DOOM look the way it does
           doom-dashboard    ; a nifty splash screen for Emacs
           doom-quit         ; DOOM quit-message prompts when you quit Emacs
           ;;fill-column       ; a `fill-column' indicator
           hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
           ;;hydra
           indent-guides     ; highlighted indent columns
           modeline          ; snazzy, Atom-inspired modeline, plus API
           nav-flash         ; blink the current line after jumping
           ;;neotree           ; a project drawer, like NERDTree for vim
           ophints           ; highlight the region an operation acts on
           (popup            ; tame sudden yet inevitable temporary windows
            +all             ; catch all popups that start with an asterix
            +defaults)       ; default popup rules
           ;;pretty-code       ; replace bits of code with pretty symbols
           tabs              ; an tab bar for Emacs
           treemacs          ; a project drawer, like neotree but cooler
           ;;unicode           ; extended unicode support for various languages
           vc-gutter         ; vcs diff in the fringe
           vi-tilde-fringe   ; fringe tildes to mark beyond EOB
           window-select     ; visually switch windows
           workspaces        ; tab emulation, persistence & separate workspaces
    
           :editor
           (evil +everywhere); come to the dark side, we have cookies
           file-templates    ; auto-snippets for empty files
           ;;god               ; run Emacs commands without modifier keys
           fold              ; (nigh) universal code folding
           ;;(format +onsave)  ; automated prettiness
           ;;lispy             ; vim for lisp, for people who dont like vim
           multiple-cursors  ; editing in many places at once
           ;;objed             ; text object editing for the innocent
           ;;parinfer          ; turn lisp into python, sort of
           rotate-text       ; cycle region at point between text candidates
           snippets          ; my elves. They type so I don't have to
           ;;word-wrap         ; soft wrapping with language-aware indent
    
           :emacs
           dired             ; making dired pretty [functional]
           electric          ; smarter, keyword-based electric-indent
           ibuffer           ; interactive buffer management
           vc                ; version-control and Emacs, sitting in a tree
    
           :term
           eshell            ; a consistent, cross-platform shell (WIP)
           ;;shell             ; a terminal REPL for Emacs
           ;;term              ; terminals in Emacs
           vterm             ; another terminals in Emacs
    
           :tools
           ;;ansible
           ;;debugger          ; FIXME stepping through code, to help you add bugs
           ;;direnv
           ;;docker
           ;;editorconfig      ; let someone else argue about tabs vs spaces
           ;;ein               ; tame Jupyter notebooks with emacs
           eval              ; run code, run (also, repls)
           flycheck          ; tasing you for every semicolon you forget
           ;;flyspell          ; tasing you for misspelling mispelling
           ;;gist              ; interacting with github gists
           (lookup           ; helps you navigate your code and documentation
            +docsets)        ; ...or in Dash docsets locally
           ;;lsp
           ;;macos             ; MacOS-specific commands
           magit             ; a git porcelain for Emacs
           ;;make              ; run make tasks from Emacs
           ;;pass              ; password manager for nerds
           ;;pdf               ; pdf enhancements
           ;;prodigy           ; FIXME managing external services & code builders
           ;;rgb               ; creating color strings
           ;;terraform         ; infrastructure as code
           ;;tmux              ; an API for interacting with tmux
           ;;upload            ; map local to remote projects via ssh/ftp
           ;;wakatime
    
           :lang
           ;;agda              ; types of types of types of types...
           ;;assembly          ; assembly for fun or debugging
           cc                ; C/C++/Obj-C madness
           ;;clojure           ; java with a lisp
           ;;common-lisp       ; if you've seen one lisp, you've seen them all
           ;;coq               ; proofs-as-programs
           ;;crystal           ; ruby at the speed of c
           ;;csharp            ; unity, .NET, and mono shenanigans
           data              ; config/data formats
           ;;erlang            ; an elegant language for a more civilized age
           ;;elixir            ; erlang done right
           ;;elm               ; care for a cup of TEA?
           emacs-lisp        ; drown in parentheses
           ;;ess               ; emacs speaks statistics
           ;;faust             ; dsp, but you get to keep your soul
           ;;fsharp           ; ML stands for Microsoft's Language
           go                ; the hipster dialect
           (haskell +intero) ; a language that's lazier than I am
           ;;hy                ; readability of scheme w/ speed of python
           ;;idris             ;
           (java +meghanada) ; the poster child for carpal tunnel syndrome
           ;;javascript        ; all(hope(abandon(ye(who(enter(here))))))
           ;;julia             ; a better, faster MATLAB
           ;;kotlin            ; a better, slicker Java(Script)
           ;;latex             ; writing papers in Emacs has never been so fun
           ;;lean
           ;;ledger            ; an accounting system in Emacs
           ;;lua               ; one-based indices? one-based indices
           markdown          ; writing docs for people to ignore
           ;;nim               ; python + lisp at the speed of c
           nix               ; I hereby declare "nix geht mehr!"
           ;;ocaml             ; an objective camel
           (org              ; organize your plain life in plain text
            +dragndrop       ; drag & drop files/images into org buffers
            ;+hugo            ; use Emacs for hugo blogging
            +ipython         ; ipython/jupyter support for babel
            +pandoc          ; export-with-pandoc support
            ;+pomodoro        ; be fruitful with the tomato technique
            +present)        ; using org-mode for presentations
           ;;perl              ; write code no one else can comprehend
           ;;php               ; perl's insecure younger brother
           ;;plantuml          ; diagrams for confusing people more
           ;;purescript        ; javascript, but functional
           python            ; beautiful is better than ugly
           ;;qt                ; the 'cutest' gui framework ever
           ;;racket            ; a DSL for DSLs
           ;;rest              ; Emacs as a REST client
           ;;ruby              ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
           ;;rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
           ;;scala             ; java, but good
           ;;scheme            ; a fully conniving family of lisps
           sh                ; she sells {ba,z,fi}sh shells on the C xor
           ;;solidity          ; do you need a blockchain? No.
           ;;swift             ; who asked for emoji variables?
           ;;terra             ; Earth and Moon in alignment for performance.
           ;;web               ; the tubes
    
           :email
           ;;(mu4e +gmail)       ; WIP
           ;;notmuch             ; WIP
           ;;(wanderlust +gmail) ; WIP
    
           ;; Applications are complex and opinionated modules that transform Emacs
           ;; toward a specific purpose. They may have additional dependencies and
           ;; should be loaded late.
           :app
           ;;calendar
           ;;irc               ; how neckbeards socialize
           ;;(rss +org)        ; emacs as an RSS reader
           ;;twitter           ; twitter client https://twitter.com/vnought
           ;;(write            ; emacs for writers (fiction, notes, papers, etc.)
           ;; +wordnut         ; wordnet (wn) search
           ;; +langtool)       ; a proofreader (grammar/style check) for Emacs
    
           :config
           ;; For literate config users. This will tangle+compile a config.org
           ;; literate config in your `doom-private-dir' whenever it changes.
           ;;literate
    
           ;; The default module sets reasonable defaults for Emacs. It also
           ;; provides a Spacemacs-inspired keybinding scheme and a smartparens
           ;; config. Use it as a reference for your own modules.
           (default +bindings +smartparens))


<a id="org19b14aa"></a>

## Config

-   Set theme
-   Do not preserve indentation while tangling code blocks.
-   Set font

    (setq doom-theme 'doom-molokai)
    (after! org
      (setq org-src-preserve-indentation nil))
    (setq treemacs-width 25)
    
    (setq doom-font (font-spec :family "IBM Plex Mono" :size 26 :weight 'semi-bold)
          doom-variable-pitch-font (font-spec :family "Fira Sans") ; inherits `doom-font''s :size
          doom-unicode-font (font-spec :family "Input Mono Narrow" :size 26)
          doom-big-font (font-spec :family "IBM Plex Mono" :size 40 :weight 'semi-bold))


<a id="org5259f8a"></a>

## Packages

Add extra packages

    (package! caddyfile-mode)
    (package! command-log-mode)
    (package! dockerfile-mode)
    (package! docker-compose-mode)


<a id="org16b0fce"></a>

# Firefox


<a id="orgc9ae31c"></a>

## Profiles

-   `StartWithLastProfile` ensures a profile choice isn&rsquo;t
    asked at startup.

Sometimes Firefox amazes me by how customizable it is. I
have <del>two</del> three profiles with Firefox; one for browsing,
one for *research* and one for web applications. Since a lot
of my research gets lost and I&rsquo;m unable to refer to previous
findings, it helps to have a separate profile. All profiles
are stored in a standardized XDG configuration directory
(`~/.config/firefox`) rather than the default
(`~/.mozilla/firefox/`). I would also rather name my own
profiles than let firefox name them randomly.

<del>I tried running Electron Apps with it but sadly, things</del>
<del>like pasting images from clipboard and downloading files</del>
<del>from Skype (yes, my workplace uses **Skype** in 2019, **groan**)</del>
<del>do not work. Hence I now rely on Ungoogled Chromium to do my</del>
<del>dirty work.</del>

<del>I tried using ungoogled chromium for dirty web apps but</del>
<del>recently, on Arch Linux, `libjsoncpp` got an update and</del>
<del>broke chromium which isn&rsquo;t as regularly built as the</del>
<del>upstream binaries. So though, clipboard interaction was a</del>
<del>sweet feature to have, I can let it go for relatively good</del>
<del>stability.</del>

Ungoogled Chromium works again!

Although things work fine with UC, I&rsquo;m unsure if Chromium
profiles actually provide a *temporary-container* sort of
isolation. I say this because tabs on different profiles
show up as normal tabs in the task manager which would mean
that an application running on one profile is externally
aware. Please correct me on this if you have more
information. I also miss the declarative configuration that
Firefox offers as I reinstall often.

    [General]
    StartWithLastProfile=1
    
    [Profile0]
    Name=Browse
    IsRelative=1
    Path=../../.config/firefox/browse
    Default=1
    
    [Profile1]
    Name=Research
    IsRelative=1
    Path=../../.config/firefox/research
    Default=0


<a id="org56ac293"></a>

## Policies

Mozilla&rsquo;s Policies&rsquo; explanation can be found [here](https://github.com/mozilla/policy-templates/blob/master/README.md).

    {
      "policies": {
        "CaptivePortal": true,
        "Cookies": {
          "Default": true,
          "AcceptThirdParty": "never",
          "ExpireAtSessionEnd": true
        },
        "DisableAppUpdate": false,
        "DisableDeveloperTools": false,
        "DisableFeedbackCommands": true,
        "DisableFirefoxAccounts": false,
        "DisableFirefoxScreenshots": true,
        "DisableFirefoxStudies": true,
        "DisableMasterPasswordCreation": true,
        "DisablePocket": true,
        "DisableProfileImport": false,
        "DisableSetDesktopBackground": false,
        "DisableSystemAddonUpdate": true,
        "DisableTelemetry": true,
        "DNSOverHTTPS": {
          "Enabled": true,
          "ProviderURL": "https://dns.quad9.net/dns-query",
          "Locked": false
        },
        "Extensions": {
          "Install": [
                       "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/httpz/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/invidition/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/umatrix/latest.xpi",
                     ],
          "Uninstall": [
                         "amazondotcom@search.mozilla.org",
                         "bing@search.mozilla.org",
                         "ebay@search.mozilla.org",
                         "google@search.mozilla.org",
                         "twitter@search.mozilla.org"
                   ],
          "Locked":  [""]
        },
        "ExtensionUpdate": true,
        "HardwareAcceleration": true,
        "NetworkPrediction": false,
        "NoDefaultBookmarks": true,
        "OfferToSaveLogins": false,
        "SanitizeOnShutdown": {
            "Cache": true,
            "Cookies": false,
            "Downloads": false,
            "FormData": false,
            "History": false,
            "Sessions": true,
            "SiteSettings": false,
            "OfflineApps": true
        },
        "SearchBar": "unified",
        "SSLVersionMin": "tls1.2"
      }
    }


<a id="org6573191"></a>

## UserJS


<a id="org1835e4a"></a>

### General

I use GHacks&rsquo; UserJS which I think is an excellent beginner
point towards making your own customizations as it allows
you to focus on tweaking for usablity from an already
privacy-centered configuration.

    /// GPU Acceleration ///
    
    // Force enable hardware acceleration
    user_pref("layers.acceleration.force-enabled", true);
    // WebRender is automatically disabled for screens < 4K
    user_pref("gfx.webrender.all", true);
    // Enable accelerated azure canvas
    user_pref("gfx.canvas.azure.accelerated", true);
    
    /// GPU Acceleration ///
    
    /// Storage ///
    
    // Do caching in RAM instead of disk
    user_pref("browser.cache.disk.enable", false);
    user_pref("browser.cache.memory.enable", true);
    
    // Save session data every 5 minutes instead of every 15 seconds
    user_pref("browser.sessionstore.interval", 300000);
    
    /// Storage ///
    
    /// Search ///
    
    // Search via address bar
    user_pref("keyword.enabled", true);
    
    // Enable suggestion of searches; safe since I use SearX
    user_pref("browser.search.suggest.enabled", true);
    user_pref("browser.urlbar.suggest.searches", true);
    
    /// Search ///
    
    
    /// Misc ///
    
    // Disable letterboxing
    user_pref("privacy.resistFingerprinting.letterboxing", false);
    
    // Enable WebAssembly
    user_pref("javascript.options.wasm", true);
    
    /// Misc ///


<a id="org0f669d7"></a>

### Themes

1.  MaterialFox

        /// MaterialFox ///
        
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("browser.tabs.tabClipWidth", 83);
        user_pref("materialFox.reduceTabOverflow", true);
        user_pref("security.insecure_connection_text.enabled", true);
        
        /// MaterialFox ///

2.  GNOME

        /// GNOME ///
        
        /* user.js
         * https://github.com/rafaelmardojai/firefox-gnome-theme/
         */
        
        // Enable customChrome.css
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        
        // Enable CSD
        user_pref("browser.tabs.drawInTitlebar", true);
        
        // Set UI density to normal
        user_pref("browser.uidensity", 0);
        
        /// GNOME ///


<a id="org6577c7b"></a>

## Setup

Functions:

-   `createWorkDir`: checks if the work directory already
    exists, removes it if it does exist (which it will, in
    case non-zero termination of the script), to start afresh.
-   `fetchGHacksJS`: fetches the source from upstream and
    navigates into the folder
-   `mkTweaks`: makes the custom user.js tweaks according to the
    option passed. Currently, supported themes are *MaterialFox*
    and *GNOME*.
-   `applyToProfiles`: reads `profiles.ini` and creates the
    specified profiles, thereafter copying the modified
    user.js files into those profiles.
-   `cleanUp`: removes the created work directory.

This script sets up my firefox profiles and custom userJS that
builds upon the GHacksUserJS.

    #!/usr/bin/env bash
    
    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE}"))
    
    mkWorkDir() {
        if [[ -d "${SCRIPT_PATH}"/workdir ]]; then
            rm -rf "${SCRIPT_PATH}"/workdir
        fi
    
        echo "Creating Work Directory..."
        mkdir -p "${SCRIPT_PATH}"/workdir
    }
    
    fetchGHacksJS() {
        echo "Fetching ghacks user.js..."
        git clone https://github.com/ghacksuserjs/ghacks-user.js.git "${SCRIPT_PATH}"/workdir/ghjs 2>/dev/null 1>&2
    }
    
    mkTweaks() {
        cp "${SCRIPT_PATH}"/*.js "${SCRIPT_PATH}"/workdir/ghjs
    
        echo "Applying userchrome tweaks..."
        case "${1}" in
            -m | --materialFox)
                cat "${SCRIPT_PATH}"/workdir/ghjs/materialfox.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
                ;;
            -g | --gnome)
                cat "${SCRIPT_PATH}"/workdir/ghjs/gnome.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
                ;;
            -n | --none)
                ;;
            -h | --help)
                echo -ne "\\nFirefox UserJS helper:
                                     -g, --gnome: apply GNOME userchrome theme
                                     -h, --help: display this message
                                     -m, --materialFox: apply MaterialFox userchrome theme
                                     -n, --none: no theme\\n"
                ;;
            *)
                echo -ne "\\nInvalid flag. Pass -h or --help for usage.\\n"
                exit 1
        esac
    
        echo "Merging tweaks with ghacks user.js..."
        "${SCRIPT_PATH}"/workdir/ghjs/updater.sh -s 2>/dev/null 1>&2
    }
    
    updateUserJS() {
        mkWorkDir
        fetchGHacksJS
        mkTweaks -n
    }
    
    applyUserJS() {
        profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')
    
        for profile in ${profileList}; do
            echo "-> Copying user.js to profile: ${profile}..."
            cp "${SCRIPT_PATH}"/workdir/ghjs/user.js "${HOME}/.config/firefox/${profile}"
        done
    }
    
    createProfilesINIDir() {
        mkdir -p "${HOME}/.mozilla/firefox"
    }
    
    applyProfilesINI() {
        ln -sf "${SCRIPT_PATH}"/profiles.ini "${HOME}/.mozilla/firefox/"
    }
    
    createProfiles() {
        profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')
    
        echo "Making profile directories..."
        for profile in ${profileList}; do
            mkdir -p "${HOME}/.config/firefox/${profile}"
        done
    }
    
    applyPolicies() {
        echo "Copying policies.json (may need root permissions)..."
    
        if [[ -d /usr/lib/firefox ]]; then
            sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox/distribution
        elif [[ -d /opt/firefox-nightly ]]; then
            sudo chown -R ${USER}:${USER} /opt/firefox-nightly
            ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-nightly/distribution
        elif [[ -d /opt/firefox-developer-edition ]]; then
            ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-developer-edition/distribution
        elif [[ -d /opt/firefox-beta ]]; then
            ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-beta/distribution
        elif [[ -d /usr/lib/firefox-developer-edition ]]; then
            sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox-developer-edition/distribution
        fi
    }
    
    cleanUp() {
        echo "Cleaning up after myself..."
        rm -rf "${SCRIPT_PATH}"/workdir
    }
    
    startFirefox() {
        $(command -v firefox) --ProfileManager 2> /dev/null || \
        $(command -v firefox-developer-edition) --ProfileManager 2> /dev/null || \
        $(command -v firefox-beta) --ProfileManager 2> /dev/null
    
        echo "Firefox is setup and started. Have a good day!"
    }


<a id="org6287c93"></a>

# Plasma


<a id="org29a6636"></a>

## Environment

    export SSH_ASKPASS="$(command -v ksshaskpass)"
    export GIT_ASKPASS="$(command -v ksshaskpass)"


<a id="org4e14a43"></a>

## PAM

    SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"


<a id="org1d0b8dd"></a>

# Systemd


<a id="org16a9c34"></a>

## SSH Agent

    [Unit]
    Description=SSH key agent
    
    [Service]
    Type=simple
    Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
    ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK
    
    [Install]
    WantedBy=default.target


<a id="orga83c2c6"></a>

# Thunderbird


<a id="org2af266c"></a>

## Profiles

This reads the same as the profiles section of Firefox.

    [General]
    StartWithLastProfile=1
    
    [Profile0]
    Name=Primary
    IsRelative=1
    Path=../.config/thunderbird/primary
    Default=1


<a id="org3fa7f77"></a>

# Ungoogled Chromium


<a id="org10f81c9"></a>

## Environment Variables

From Debian bug tracker:

> As can be seen in the upstream discussion, this happens whenever mesa
> drivers are used since threads are used in their GLSL shader
> implementation.  This does have a consequence, chromium&rsquo;s GPU driver
> will not be sandboxed.  You can see this in about:gpu.
> 
> Also seen upstream, it should be possible to work around the problem
> by setting MESA<sub>GLSL</sub><sub>CACHE</sub><sub>DISABLE</sub>=true.
> 
> Best wishes,
> Mike

    MESA_GLSL_CACHE_DISABLE=true


<a id="orgf369b9a"></a>

## Flags

A better explanation can be found [here](https://peter.sh/experiments/chromium-command-line-switches/).

    # Disable workarounds for various GPU driver bugs.
    # --disable-gpu-driver-bug-workarounds
    # Enable hardware acceleration
    --enable-accelerated-mjpeg-decode
    --enable-accelerated-video
    --enable-gpu-rasterization
    --enable-native-gpu-memory-buffers
    --enable-zero-copy
    --ignore-gpu-blacklist
    # Disables the crash reporting.
    --disable-breakpad
    # Disables cloud backup feature.
    --disable-cloud-import
    # Disables installation of default apps on first run. This is used during automated testing.
    --disable-default-apps
    # Disables the new Google favicon server for fetching favicons for Most Likely tiles on the New Tab Page.
    --disable-ntp-most-likely-favicons-from-server
    # Disables showing popular sites on the NTP.
    --disable-ntp-popular-sites
    # Disable auto-reload of error pages if offline.
    --disable-offline-auto-reload
    # Disables sign-in promo.
    --disable-signin-promo
    # The "disable" flag for kEnableSingleClickAutofill.
    --disable-single-click-autofill
    # Disables syncing browser data to a Google Account.
    --disable-sync
    # Disables the default browser check. Useful for UI/browser tests where we want to avoid having the default browser info-bar displayed.
    --no-default-browser-check
    # Don't send hyperlink auditing pings.
    --no-pings
    # Enable Dark Mode
    --force-dark-mode
    --enable-features=WebUIDarkMode


<a id="org0c2dae8"></a>

# Scripts

A crontab entry (as root, wherever needed) can be added to automate periodic builds / runs.

A few guidelines followed throughout these scripts:

-   Output is silenced and is replaced by friendly messages.
-   Errors are handled explicitly instead of letting the script fail.
-   Each task is divided into functions, no matter how small.
    The main function looks like nothing more than a series of steps (function calls).
-   Documentation for what the function does and why is provided.
-   A `$SCRIPT_PATH` is defined to determine the path of the each script.


<a id="orgecf11a3"></a>

## General


<a id="org294df96"></a>

### Ungoogled Chromium Extension Updater

-   `USER_DATA_DIR` is your data directory for Chromium.
    Normally, it is $HOME/.config/chromium. However since I
    sync my chromium profiles using Nextcloud and only use it
    for web applications; I like to keep it separated from the
    default installation.
-   `EXT_DIR` is the directory where extensions are stored.
-   `EXTID_LIST` is the list of all extensions you have
    installed currently. The list is fetched from the data
    directory, excluding the *Temp* directory.
-   `CHROMIUM_VERSION` fetches the major version of chromium
    that is installed.

For this function to work, you must set
`chrome://flags/#extension-mime-request-handling` to *Always
prompt for install* for automatic prompts. A truly
unattended way of updating extensions is not possible at
this moment.

    # import sanity
    set -euo pipefail
    
    # global declarations
    USER_DATA_DIR="${HOME}/.config/chromium/Apps"
    EXT_DIR="${USER_DATA_DIR}/Default/Extensions"
    EXTID_LIST=$(ls -1 "${EXT_DIR}" | grep -v Temp)
    CHROMIUM_VERSION=$($(command -v chromium) --version | grep -o '\s[0-9][0-9]\.[0-9]' | tr -d ' ')
    
    printDetails() {
        echo -e "Your Chromium version is ${CHROMIUM_VERSION}.\nYour profile is located at ${USER_DATA_DIR}."
    }
    
    checkForUpdate() {
        if [[ $((10#${1})) -gt $((10#${2})) ]]; then
            return 0
        else
            return 1
        fi
    }
    
    installExtension() {
        $(command -v chromium) --user-data-dir="${USER_DATA_DIR}" "${1}"
    }
    
    main() {
        printDetails
    
        for extID in ${EXTID_LIST}; do
            UPDATE_URL="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${CHROMIUM_VERSION}&x=id%3D${extID}%26installsource%3Dondemand%26uc"
    
            if [[ -n $(ls -1 "${EXT_DIR}/${extID}") ]]; then
                oldVersion=$(ls -1 "${EXT_DIR}/${extID}" | tail -1 | sed 's/\.//g; s/\_//g')
                newVersion=$(curl -s "${UPDATE_URL}" | grep --only extension_[0-9]*_[0-9]*_[0-9]*.*.crx | sed -e 's/extension_//g; s/\.crx//g; s/\.//g; s/\_//g')
    
                if checkForUpdate "${newVersion}" "${oldVersion}"; then
                    installExtension "${UPDATE_URL}"
                fi
            else
                installExtension "${UPDATE_URL}"
            fi
        done
    }
    
    main "${@}"


<a id="orgd4bd480"></a>

### Wallpaper Index

Variables:

-   `WALL_STORAGE_PATH` holds the location where the indexed
    wallpapers are kept. Default value is
    `$HOME/Pictures/Wallpapers/Wallhaven` (expected to change in
    the future).
-   `WALL_TEMP_PATH` holds the location where the wallpapers
    are downloaded or wherever they are kept unorganized.
    Default value is $HOME/Downloads.

Functions:

-   `changeWallStoragePath` prompts for a new location for
    `WALL_STORAGE_PATH` and proceeds normally if
    
    -   the response is any of &ldquo;y&rdquo;, &ldquo;Y&rdquo;, &ldquo;yes&rdquo;, &ldquo;YES&rdquo;, etc and the entered path exists
    -   the response is any of &ldquo;n&rdquo;, &ldquo;N&rdquo;, &ldquo;no&rdquo;, &ldquo;NO&rdquo;, etc
    
    In case of an invalid response, the prompt is shown again.
-   `changeWallTempPath` is exactly the same as
    `changeWallStoragePath` but for `WALL_TEMP_PATH`.
-   `rename` does the following:
    -   reads the last index from `WALL_STORAGE_PATH` and
        wallpaper list from `WALL_TEMP_PATH`
    -   runs through the list of wallpapers, separates extension
        from name in order to preserve it in the renamed file
    -   renames files with a message saying so
    -   updates the index after each rename
-   `main`, unless either of &ldquo;-s&rdquo; or &ldquo;&#x2013;silent&rdquo; is passed,
    proceeds to invoke all functions.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    WALL_STORAGE_PATH="${HOME}/Pictures/Wallpapers/Wallhaven"
    WALL_TEMP_PATH="${HOME}/Downloads"
    
    changeWallStoragePath() {
        while true; do
            echo -ne "Wallpapers storage path is currently set to ${WALL_STORAGE_PATH}. Do you want to change it? "
            read -r resp
    
            echo
            case "${resp}" in
                [yY]|[yY][eE][Ss])
                    echo -ne "Please enter a path for wallpaper storage: "
                    read -r WALL_STORAGE_PATH
    
                    echo
                    if [[ ! -d "${WALL_STORAGE_PATH}" ]]; then
                        echo "You've entered a path that does not exist."
                        continue
                    else
                        break
                    fi
                    ;;
                [nN]|[nN][oO])
                    break
                    ;;
                *)
                    echo -e "Invalid response."
                    continue
            esac
        done
    }
    
    changeWallTempPath() {
        while true; do
            echo -ne "Wallpapers temporary storage path is currently set to ${WALL_TEMP_PATH}. Do you want to change it? "
            read -r resp
    
            echo
            case "${resp}" in
                [yY]|[yY][eE][Ss])
                    echo -ne "Please enter a path for wallpaper storage: "
                    read -r WALL_TEMP_PATH
    
                    echo
                    if [[ ! -d "${WALL_TEMP_PATH}" ]]; then
                        echo "You've entered a path that does not exist."
                        continue
                    else
                        break
                    fi
                    ;;
                [nN]|[nN][oO])
                    break
                    ;;
                *)
                    echo -e "Invalid response."
                    continue
            esac
        done
    }
    
    rename() {
        lastIndex=$(ls -1 --sort=version "${WALL_STORAGE_PATH}" | grep -E '^[0-9]+\.[a-z]+$' | tail -1 | cut -d '.' -f1)
        wallList=$(ls -1 --sort=time "${WALL_TEMP_PATH}" | grep -E '^[wW]allhaven.*')
    
        echo -e "Renaming wallpapers..."
        for wall in ${wallList}; do
            ext=$(echo "${wall}" | cut -d '.' -f2)
            if mv "${WALL_TEMP_PATH}/${wall}" "${WALL_STORAGE_PATH}/$((lastIndex + 1)).${ext}"; then
                echo -e "${WALL_TEMP_PATH}/${wall} has been renamed to ${WALL_STORAGE_PATH}/$((lastIndex + 1)).${ext}"
            else
                echo -e "File ${WALL_TEMP_PATH}/${wall} could not be renamed."
                exit 1
            fi
    
            lastIndex="$((lastIndex + 1))"
        done
    }
    
    main() {
        set +u
        case "${1}" in
            "-s"|"--silent")
                rename 1>/dev/null 2>&1
                ;;
        esac
        set -u
    
        changeWallStoragePath
        changeWallTempPath
        rename
    }
    
    main


<a id="orgfcb4f25"></a>

## TODO Helpers     :documentation:


<a id="orgbfa5796"></a>

### Bash Sanity

Bash has some very /meme/worthy behaviour by default. The
other day somebody on Reddit was crying because he
accidentally deleted all files in his root directory because:

1.  His script did not terminate when a command failed.
2.  The failing command&rsquo;s purpose was to assign a base path
    to a variable.

And this happens every other day to some shell beginner out
there. Hence, this script tries to restore sanity to shell
scripts.

-   `errexit` terminates the script immediately if a command
    returns a non-zero exit code. It can be temporary bypassed
    by appending a `|| true` which makes the complete command
    exit with zero.
-   `pipefail` terminates the script immediately if *part* of
    the pipe chain exits with a non-zero code.
-   `nounset` ensures all variables have been assigned a value
    before they are referred. Upon encountering an empty
    variable, terminates the script. `VAR=` is a valid
    assignment.

    # Bash Sanity
    # https://kvz.io/blog/2013/11/21/bash-best-practices/
    # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
    # Exit script if a command fails
    # Use: cmd || true to bypass
    set -o errexit # aka: set -e
    # Exit script if the left side of a pipe fails
    set -o pipefail
    # Exit if a variable is used but not assigned
    set -o nounset # aka: set -u
    # DEBUG MODE
    # Show output of statements as they are being executed
    # set -o xtrace # aka: set -x


<a id="orgb20bd43"></a>

### Run Script

`run()` is a wrapper around eval which itself takes args, concatenates them and
runs the concatenated string as a command. Any form of output is silenced. If
`eval` succeeds, a tick mark is displayed and if it doesn&rsquo;t, a cross mark is
displayed. An `exit` has to explicitly stated and `set -o errexit`

    run() {
        if eval "${@}" 2>/dev/null 1>&2; then
            printf '\u2714\n'
        else
            printf '\u274c\n'
            exit 1
        fi
    }


<a id="orgababe62"></a>

### Fetch Source

This function fetches the source from the given URL and displays a tick or cross
mark depending on exit code.

    # global declarations
    export SCRIPT_PATH=$(dirname $(realpath "$0"))
    
    fetchSource() {
        export URL="${1}"
        export REPO_NAME=$(echo "${URL}" | cut -d '/' -f5 | cut -d '.' -f1)
    
        if [[ -d "${SCRIPT_PATH}/${REPO_NAME}" ]]; then
            cleanUp
        fi
    
        echo -ne "Fetching source..."
        run git clone --quiet "${URL}" "${SCRIPT_PATH}/${REPO_NAME}"
    }


<a id="orge78f1b7"></a>

### Cleanup

    cleanUp() {
        echo -ne "Cleaning up all the cruft..."
    
        run rm -rf "${SCRIPT_PATH}/${REPO_NAME}"
    }


<a id="orgff782cd"></a>

## Plasma


<a id="org66e38c5"></a>

### Virtual Desktop Bar (KDE)

-   `fetchSource` gets the latest master from github and
    places it in a subdirectory.
-   `installDeps` installs the missing dependencies required
    for building virtual desktop bar.
-   `buildTarget` executes a list of commands as mentioned on
    the github page for building the widget.
-   `installTarget` runs `make install` to copy the built
    target into the appropriate plasma directory.
-   Lastly, `cleanUp` removes the downloaded source.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    URL="https://github.com/wsdfhjxc/virtual-desktop-bar.git"
    
    fetchSource() {
        echo -e "Fetching source..."
        if git clone --quiet "${URL}" "${SCRIPT_PATH}"/virtual-desktop-bar; then
            echo -e "\t-> Source fetched successfully."
        else
            echo -e "\t-> Source couldn't be fetched."
        fi
    }
    
    installDeps() {
        echo -e "Installing dependencies (if any)..."
    
        if sudo pacman --sync --noconfirm --needed cmake extra-cmake-modules gcc 1> /dev/null 2>&1; then
            echo -e "\t-> Installed all required dependencies."
        else
            echo -e "\t-> All dependencies could not be installed!"
        fi
    }
    
    buildTarget() {
        cd "${SCRIPT_PATH}"/virtual-desktop-bar
        mkdir -p "${SCRIPT_PATH}"/virtual-desktop-bar/build
        cd "${SCRIPT_PATH}"/virtual-desktop-bar/build
    
        echo -e "Generating configuration..."
        if cmake "${SCRIPT_PATH}"/virtual-desktop-bar 1> /dev/null 2>&1; then
            echo -e "\t-> Configuration generated."
        else
            echo -e "\t-> Configuration generation failed!"
        fi
    
        echo -e "Building Virtual Desktop Bar..."
        if make -j$(nproc) 1> /dev/null; then
            echo -e "\t-> Building successful."
        else
            echo -e "\t-> Building failed!"
        fi
    }
    
    installTarget() {
        cd "${SCRIPT_PATH}"/virtual-desktop-bar/build
    
        echo -e "Installing target (need root permissions)..."
        if sudo make install 1> /dev/null 2>&1; then
            echo -e "\t-> Installing successful."
        else
            echo -e "\t-> Installing failed!"
        fi
    }
    
    cleanUp() {
        echo -e "Cleaning up all the cruft..."
        rm -rf "${SCRIPT_PATH}"/virtual-desktop-bar
    }
    
    main() {
        if [[ -d "${SCRIPT_PATH}"/virtual-desktop-bar ]]; then
            cleanUp
        fi
    
        fetchSource
        installDeps
        buildTarget
        installTarget
        cleanUp
    }
    
    main


<a id="org9baed8c"></a>

### KWin Tiling Script (Faho)

Mostly the same as *Virtual Desktop Bar* sans the building.
The quirk here is to symlink a `.desktop` file for the gooey
configuration section to appear.

There is also an update step which is necessary if the
script has been previously installed.

    # import sanity
    set -euo pipefail
    
    # global declarations
    SCRIPT_PATH=$(dirname $(realpath "$0"))
    URL="https://github.com/kwin-scripts/kwin-tiling.git"
    
    fetchSource() {
        echo -e "Fetching source..."
        if git clone --quiet "${URL}" "${SCRIPT_PATH}"/kwin-tiling; then
            echo -e "\t-> Source fetched successfully."
        else
            echo -e "\t-> Source couldn't be fetched."
        fi
    }
    
    installScript() {
        echo -e "Installing KWin Tiling Script..."
        if plasmapkg2 --type kwinscript --install "${SCRIPT_PATH}"/kwin-tiling 1>/dev/null 2>&1; then
            echo -e "\t-> Installation successful."
        else
            echo -e "\t-> Installation failed!"
        fi
    }
    
    updateScript() {
        echo -e "Updating KWin Tiling Script..."
        if plasmapkg2 --type kwinscript --upgrade "${SCRIPT_PATH}"/kwin-tiling 1> /dev/null 2>&1; then
            echo -e "\t-> Update successful."
        else
            echo -e "\t-> Update failed!"
        fi
    }
    
    fixConf() {
        # necessary for configuration option in KWin Scripts menu
        mkdir -p "${HOME}"/.local/share/kservices5
        ln -sf "${HOME}"/.local/share/kwin/scripts/kwin-script-tiling/metadata.desktop "${HOME}"/.local/share/kservices5/kwin-script-tiling.desktop
    }
    
    cleanUp() {
        echo -e "Cleaning up all the cruft..."
        rm -rf "${SCRIPT_PATH}"/kwin-tiling
    }
    
    main() {
        if [[ -d "${SCRIPT_PATH}"/kwin-tiling ]]; then
            cleanUp
        fi
    
        fetchSource
        if [[ -d /home/kayg/.local/share/kwin/scripts/kwin-script-tiling ]]; then
            updateScript
        else
            installScript
        fi
    
        fixConf
        cleanUp
    }
    
    main


<a id="org0c5abc6"></a>

## TODO Spotify     :documentation:


<a id="orgef44454"></a>

### WM Name

Spotify treats Linux as a second-class citizen. Everybody knows that. We&rsquo;re glad
to at least have a client, right? But that does not mean the community can&rsquo;t fix
problems that can be fixed. When Spotify starts, it does not set $WM<sub>CLASS</sub> which
becomes a problem for window managers if a custom layout or custom changes are
to be defined for that particular window. A simple fix was provided [here](https://github.com/dasJ/spotifywm) (hasn&rsquo;t
been updated in years but still works).

    export SCRIPT_PATH=$(dirname $(realpath "$0"))
    
    buildLibrary() {
        cd "${SCRIPT_PATH}/spotifywm"
    
        echo -ne "Building library..."
        run make -j$(nproc)
    }
    
    moveLibrary() {
       echo -ne "Moving built library to /usr/lib (need root permissions)...\nEnter password, please: "
       run sudo --prompt="" mv "${SCRIPT_PATH}/spotifywm/spotifywm.so" /usr/lib
    }
    
    fixSpotify() {
        echo -ne "Moving desktop file to local directory to make above changes..."
        run cp /usr/share/applications/spotify.desktop "${HOME}"/.local/share/applications
    
        echo -ne "Making changes in the desktop file..."
        run "sed -Ei 's/^Exec=(.*)/Exec=LD_PRELOAD=\/usr\/lib\/spotifywm.so \1/g' "${HOME}"/.local/share/applications/spotify.desktop"
    }
    
    main() {
        source "${SCRIPT_PATH}/helper"
    
        fetchSource "https://github.com/dasJ/spotifywm"
        buildLibrary
        moveLibrary
        fixSpotify
        cleanUp
    }
    
    main


<a id="org9c39fbe"></a>

### Lyrics

One of the things I miss from Deezer is the seamless integration of lyrics (for
a select few songs, at least) into the app / webapp itself. I hear the same
worked for Spotify a few years ago but they lost the license for lyrics with
their lyrics provider / partner. So I found [this](https://github.com/SwagLyrics/SwagLyrics-For-Spotify) which queries the song title
from the running Spotify app, fetches lyrics and opens an issue on Github
automatically if it can&rsquo;t find those lyrics. Pretty cool, right?

    # global declarations
    export SCRIPT_PATH=$(dirname $(realpath "$0"))
    
    checkDeps() {
        echo -ne "Checking for existence of python..."
        run command -v python
    
        echo -ne "Checking for existence of pip..."
        run command -v pip
    }
    
    installSL() {
        echo -ne "Installing SwagLyrics if it does not already exist..."
        run $(command -v pip) install --user swaglyrics
    }
    
    main() {
        source "${SCRIPT_PATH}/helper"
    
        checkDeps
        installSL
    }
    
    main


<a id="orga43238d"></a>

### Theme

    # global declarations
    export SCRIPT_PATH=$(dirname $(realpath "$0"))
    
    checkSpicetify() {
        echo -ne "Checking if Spicetify exists... "
        run command -v spicetify
    }


<a id="orgafcd288"></a>

# ZSH


<a id="org671b6ab"></a>

## Oh-my-zsh stuff

Settings specific to OMZ.

    # Path to oh-my-zsh installation.
    export ZSH="${HOME}/.config/omz"
    
    # Set OMZ theme
    ZSH_THEME="agnoster"
    
    # _ and - will be interchangeable.
    HYPHEN_INSENSITIVE="true"
    
    # Enable command auto-correction.
    ENABLE_CORRECTION="true"
    
    # Display red dots whilst waiting for completion.
    COMPLETION_WAITING_DOTS="true"
    
    # Too many plugins slow down shell startup.
    # Plugins can be found in $ZSH/plugins
    plugins=(
        copyfile
        git
        vi-mode
        z
        zsh-syntax-highlighting
        zsh-autosuggestions
    )
    
    source "${ZSH}"/oh-my-zsh.sh


<a id="org0a8b1d7"></a>

## Functions


<a id="org540dabc"></a>

### Weather

Fetches the current weather from wttr.in, assumes my city
unless specified otherwise.

    wttr() {
        curl https://wttr.in/${1:-Bhubaneswar}
    }


<a id="orge96e996"></a>

## Variables

    # PATH
    export PATH="${HOME}/.emacs.d/bin:${HOME}/.local/bin:${PATH}"
    
    # GO
    export GOPATH="${HOME}/.go"
    export GOBIN="${HOME}/.local/bin"
    
    # ZSH
    # Fetch suggestions asynchronously
    export ZSH_AUTOSUGGEST_USE_ASYNC=1
    # order of strategies to try
    export ZSH_AUTOSUGGEST_STRATEGY=(
        match_prev_cmd
        completion
    )
    # Avoid autosuggestions for buffers that are too large
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20


<a id="orgbc9763e"></a>

## Aliases

    if command -v kitty 2>/dev/null 1>&2; then
        alias icat="kitty +kitten icat"
    fi
    
    alias vim='emacsclient -nw'


<a id="org42edea4"></a>

## Source

    if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
        source /usr/share/nvm/init-nvm.sh
    fi

