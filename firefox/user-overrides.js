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

/// Misc ///
