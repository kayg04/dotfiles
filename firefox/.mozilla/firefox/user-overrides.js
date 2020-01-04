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

// Browser extensions
user_pref("browser.policies.runOncePerModification.extensionsInstall", [
    "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/httpz/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/invidition/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
    "https://addons.mozilla.org/firefox/downloads/latest/umatrix/latest.xpi"
]);

user_pref("browser.policies.runOncePerModification.extensionsUninstall", [
    "amazondotcom@search.mozilla.org",
    "bing@search.mozilla.org",
    "ebay@search.mozilla.org",
    "google@search.mozilla.org",
    "twitter@search.mozilla.org"
]);

// Enable captive portal
user_pref("etwork.captive-portal-service.enabled", true);

// Don't clear cookies on shutdown
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.formdata", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.openWindows", false);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.siteSettings", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);

// Disable all the firefox cruft
user_pref("extensions.pocket.disabled", true);
user_pref("extensions.screenshots.disabled", true);
user_pref("browser.contentblocking.report.lockwise.enabled", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Don't restore default bookmarks
user_pref("browser.bookmarks.restore_default_bookmarks", false);

// Use DuckDuckGo as pinned search shortcut
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned", "duckduckgo");

/// Misc ///
