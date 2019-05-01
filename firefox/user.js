// Disable WebRTC completely
user_pref("media.peerconnection.enabled", false);
user_pref("media.peerconnection.turn.disable", true);
user_pref("media.peerconnection.use_document_iceservers", false);
user_pref("media.peerconnection.video.enabled", false);
user_pref("media.peerconnection.identity.timeout", 1);

// A result of the Tor Uplift effort, this preference makes Firefox more resistant to browser fingerprinting.
user_pref("privacy.resistFingerprinting", true);

// Disables offline cache.
user_pref("browser.cache.offline.enable", false);

// Disable Google Safe Browsing malware checks. Security risk, but privacy improvement.
user_pref("browser.safebrowsing.malware.enabled", false);

// Disable Google Safe Browsing and phishing protection. Security risk, but privacy improvement.
user_pref("browser.safebrowsing.phishing.enabled", false);

// The attribute would be useful for letting websites track visitors' clicks.
user_pref("browser.send_pings", false);

// Even with Firefox set to not remember history, your closed tabs are stored temporarily at Menu -> History -> Recently Closed Tabs.
user_pref("browser.sessionstore.max_tabs_undo", 0);

// Disable preloading of autocomplete URLs. Firefox preloads URLs that autocomplete when a user types into the address bar, which is a concern if URLs are suggested that the user does not want to connect to.
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// Website owners can track the battery status of your device.
user_pref("dom.battery.enabled", false);

// Disable that websites can get notifications if you copy, paste, or cut something from a web page, and it lets them know which part of the page had been selected.
user_pref("dom.event.clipboardevents.enabled", false);

// Disables GeoLocation
user_pref("geo.enabled", false);

// Disables playback of DRM-controlled HTML5 content, which, if enabled, automatically downloads the Widevine Content Decryption Module provided by Google Inc. DRM-controlled content that requires the Adobe Flash or Microsoft Silverlight NPAPI plugins will still play, if installed and enabled in Firefox.
user_pref("media.eme.enabled", false);

// Disables the Widevine Content Decryption Module provided by Google Inc., used for the playback of DRM-controlled HTML5 content.
user_pref("media.gmp-widevinecdm.enabled", false);

// Websites can track the microphone and camera status of your device.
user_pref("media.navigator.enabled", false);

// Only accept from the originating site (block third-party cookies)
user_pref("network.cookie.cookieBehavior", 1);

// Accept cookies for current session only
user_pref("network.cookie.lifetimePolicy", 2);

// Send only the scheme, host, and port in the Referer header 
user_pref("network.http.referer.trimmingPolicy", 2);

// Only send Referer header when the full hostnames match.
user_pref("network.http.referer.XOriginPolicy", 2);

// When sending Referer across origins, only send scheme, host, and port in the Referer header of cross-origin requests.
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// WebGL is a potential security risk.
user_pref("webgl.disabled", true);

// Never store extra session data.
user_pref("browser.sessionstore.privacy_level", 2);

// Not rendering IDNs as their Punycode equivalent leaves you open to phishing attacks that can be very difficult to notice.
user_pref("network.IDN_show_punycode", true);

// Limit the amount of identifiable information sent when requesting the Mozilla harmful extension blocklist. 
user_pref("extensions.blocklist.url", "https://blocklists.settings.services.mozilla.com/v1/blocklist/3/%20/%20/");

// Force enable hardware acceleration
user_pref("layers.acceleration.force-enabled", true);

// Disable Firefox native extensions
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);
user_pref("extensions.formautofill.address.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.reauth.enabled", false);
user_pref("extensions.formautofill.section.enabled", false);
user_pref("extensions.formautofill.firstTimeUse", false);

// Modal Highlighted Search
user_pref("findbar.modalHighlight", true);

// Do not allow non e10s compatible addons to run on e10s
user_pref("extensions.interposition.enabled", false);

// Mark HTTP as insecure
user_pref("security.insecure_connection_icon.enabled", true);

// Block insecure media
user_pref("security.mixed_content.block_display_content", true);

// Show HTTP in the URL
user_pref("browser.urlbar.trimURLs", false);

// WebRender is automatically disabled for screens < 4K
user_pref("gfx.webrender.all", true);

// Enable accelerated azure canvas
user_pref("gfx.canvas.azure.accelerated", true);

// Do caching in RAM instead of disk
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);

// Save session data every 5 minutes instead of every 15 seconds
user_pref("browser.sessionstore.interval", 300000);

// MaterialFox
user_pref("svg.context-properties.content.enabled", true);
user_pref("browser.tabs.tabClipWidth", 83);
user_pref("materialFox.reduceTabOverflow", true);
user_pref("security.insecure_connection_text.enabled", true);

// Enable additional media codecs
user_pref("media.mediasource.enabled", true);
user_pref("media.mediasource.mp4.enabled", true);
user_pref("media.mediasource.webm.enabled", true);
user_pref("media.mediasource.ignore_codecs", true);
user_pref("media.av1.enabled", true);

// Disable fullscreen warning
user_pref("full-screen-api.warning.timeout", 0);

// Smooth scrolling
user_pref("mousewheel.min_line_scroll_amount", 40);
user_pref("general.smoothScroll", false);
user_pref("general.smoothScroll.pages", false);
user_pref("image.mem.min_discard_timeout_ms", 2100000000);
user_pref("image.mem.max_decoded_image_kb", 2048);

// Don't sync themes
user_pref("services.sync.prefs.sync.lightweightThemes.selectedThemeID", false);

// DNS over HTTPS
user_pref("network.trr.mode", 2); // Use DNS-over-HTTPS as main, plain DNS as fallback
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.bootstrapAddress", "9.9.9.9");

// Sync search engines
user_pref("services.sync.engine.addresses", true);
user_pref("services.sync.engine.addresses.available", true);
