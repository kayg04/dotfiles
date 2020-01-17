// +++ GPU +++ //

// Force enable hardware acceleration
user_pref("layers.acceleration.force-enabled", true);
// WebRender is automatically disabled for screens < 4K
user_pref("gfx.webrender.all", true);
// Enable accelerated azure canvas
user_pref("gfx.canvas.azure.accelerated", true);

// --- GPU --- //

// +++ Storage +++ //

// A lot of I/O is not a problem on NVMe(s)
user_pref("browser.cache.disk.enable", true);

// Save session data every 5 minutes instead of every 15 seconds
user_pref("browser.sessionstore.interval", 300000);

// --- Storage --- //

// +++ Search +++ //

// Search via address bar
user_pref("keyword.enabled", true);

// Enable suggestion of searches; safe since I use DDG and SearX
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.searches", true);

// --- Search --- //

// +++ Misc +++ //

// Disable letterboxing
user_pref("privacy.resistFingerprinting.letterboxing", false);

// Enable WebAssembly
user_pref("javascript.options.wasm", true);

// Don't clear either of downloads, history or cookies on shutdown
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.history", false);

// Disable all the firefox cruft
user_pref("extensions.pocket.disabled", true);
user_pref("extensions.screenshots.disabled", true);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
user_pref("browser.contentblocking.report.lockwise.enabled", false);

// Disable firefox recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Don't restore default bookmarks
user_pref("browser.bookmarks.restore_default_bookmarks", false);

// Do not display pinned search engines at the bottom of the address bar
user_pref("browser.urlbar.oneOffSearches", false);

// Do not ask to save logins, Bitwarden already does that
user_pref("signon.rememberSignons", false);

// Safe Negotiation is not a priority as it breaks a lot of banking portals in
// my country
user_pref("security.ssl.require_safe_negotiation", false);

// --- Misc --- //
