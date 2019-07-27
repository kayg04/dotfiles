
# Table of Contents

1.  [Firefox](#org568e91d)
    1.  [Profiles](#orgb9a26a8)
    2.  [Policies](#org6ee4538)
    3.  [UserJS](#org5471f48)
2.  [Emacs](#org9ed7581)



<a id="org568e91d"></a>

# Firefox


<a id="orgb9a26a8"></a>

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
Skype (yes, my workplace uses **Skype** in 2019 \\\*groan\\\*) do
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


<a id="org6ee4538"></a>

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


<a id="org5471f48"></a>

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


<a id="org9ed7581"></a>

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

