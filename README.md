
# Table of Contents

1.  [Compton](#org0773941)
2.  [Emacs](#org772bc8b)
3.  [Firefox](#orgeb063c9)
    1.  [Profiles](#org0d7c883)
    2.  [Policies](#org9a39c72)
    3.  [UserJS](#orgc61d517)



<a id="org0773941"></a>

# Compton

    # Shadow
    shadow = true;
    no-dnd-shadow = true;
    no-dock-shadow = true;
    clear-shadow = true;
    shadow-radius = 7;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    # shadow-opacity = 0.7;
    # shadow-red = 0.0;
    # shadow-green = 0.0;
    # shadow-blue = 0.0;
    shadow-exclude = [
        "name = 'Notification'",
        "class_g = 'Conky'",
        "class_g ?= 'Notify-osd'",
        "class_g = 'Cairo-clock'",
        "_GTK_FRAME_EXTENTS@:c"
    ];
    # shadow-exclude = "n:e:Notification";
    # shadow-exclude-reg = "x10+0+0";
    # xinerama-shadow-crop = true;
    
    # Opacity
    menu-opacity = 0.8;
    inactive-opacity = 0.8;
    # active-opacity = 0.8;
    frame-opacity = 0.7;
    inactive-opacity-override = false;
    alpha-step = 0.06;
    # inactive-dim = 0.2;
    # inactive-dim-fixed = true;
    blur-background = true;
    blur-background-frame = true;
    blur-method = "kawase";
    blur-strength = 7;
    blur-kern = "3x3box";
    # blur-kern = "5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1";
    # blur-background-fixed = true;
    blur-background-exclude = [
        "window_type = 'dock'",
        "window_type = 'desktop'",
        "_GTK_FRAME_EXTENTS@:c"
    ];
    # opacity-rule = [ "80:class_g = 'URxvt'" ];
    
    # Fading
    fading = true;
    # fade-delta = 30;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    # no-fading-openclose = true;
    # no-fading-destroyed-argb = true;
    fade-exclude = [ ];
    
    # Other
    backend = "glx";
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    # use-ewmh-active-win = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    refresh-rate = 0;
    vsync = "opengl";
    dbe = false;
    paint-on-overlay = true;
    # sw-opti = true;
    # unredir-if-possible = true;
    # unredir-if-possible-delay = 5000;
    # unredir-if-possible-exclude = [ ];
    focus-exclude = [ "class_g = 'Cairo-clock'" ];
    detect-transient = true;
    detect-client-leader = true;
    invert-color-include = [ ];
    # resize-damage = 1;
    
    # GLX backend
    glx-no-stencil = true;
    glx-copy-from-front = false;
    # glx-use-copysubbuffermesa = true;
    # glx-no-rebind-pixmap = true;
    glx-swap-method = "undefined";
    # glx-use-gpushader4 = true;
    # xrender-sync = true;
    # xrender-sync-fence = true;
    
    # Window type settings
    wintypes:
    {
      tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; };
    };
    
    # Transitions
    transition-length = 100;


<a id="org772bc8b"></a>

# Emacs

Since Emacs' settings are already managed through an org
file, there is no need to go meta. This is the init.el file
which emacs first reads and uses it tangle its full
configuration elsewhere.

    (require 'org)
    (setq-default user-emacs-directory "~/.config/emacs/")
    (org-babel-load-file
     (expand-file-name "settings.org"
                       user-emacs-directory))


<a id="orgeb063c9"></a>

# Firefox


<a id="org0d7c883"></a>

## Profiles

-   `StartWithLastProfile` ensures a profile choice isn't
    asked at startup.

Sometimes Firefox amazes me by how customizable it is. I
have two profiles with Firefox; one for browsing and one for
*research*. Since a lot of my research gets lost and I'm
unable to refer to previous findings, it helps to have a
separate profile. Both profiles are stored in a standardized
XDG configuration directory (`~/.config/firefox`) rather
than the default (`~/.mozilla/firefox/`). I would also
rather name my own profiles than let firefox name them
randomly.

I tried running Electron Apps with it but sadly, things like
pasting images from clipboard and downloading files from
Skype (yes, my workplace uses **Skype** in 2019, **groan**) do
not work. Hence I now rely on Ungoogled Chromium to do my
dirty work.

Although things work fine with UC, I'm unsure if Chromium
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
    Path=../../.config/firefox/firefox.browse
    Default=1
    
    [Profile1]
    Name=Research
    IsRelative=1
    Path=../../.config/firefox/firefox.research
    Default=0


<a id="org9a39c72"></a>

## Policies

Mozilla's Policies' explanation can be found [here](https://github.com/mozilla/policy-templates/blob/master/README.md).

    {
      "policies": {
        "CaptivePortal": true,
        "Cookies": {
          "Default": true,
          "AcceptThirdParty": "never",
          "ExpireAtSessionEnd": true
        },
        "DisableAppUpdate": true,
        "DisableDeveloperTools": false,
        "DisableFeedbackCommands": true,
        "DisableFirefoxAccounts": false,
        "DisableFirefoxScreenshots": true,
        "DisableFirefoxStudies": false,
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
                       "https://addons.mozilla.org/firefox/downloads/latest/peertubeify/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/umatrix/latest.xpi",
                       "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi"
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
            "Cookies": true,
            "Downloads": false,
            "FormData": false,
            "History": false,
            "Sessions": true,
            "SiteSettings": true,
            "OfflineApps": true
        },
        "SearchBar": "unified",
        "SSLVersionMin": "tls1.2"
      }
    }


<a id="orgc61d517"></a>

## UserJS

I use GHacks' UserJS which I think is an excellent beginner
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

