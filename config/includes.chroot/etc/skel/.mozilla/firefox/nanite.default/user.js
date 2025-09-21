// Nanite Linux Firefox ESR Configuration
// This file configures Firefox for all new users

// 1. Set multiple homepages (separated by |)
user_pref("browser.startup.homepage", "https://nanite.software|https://yashbhangale.github.io");

// 2. Tell Firefox to show the homepage on startup (1 = homepage, 3 = previous session)
user_pref("browser.startup.page", 1);

// 3. Enable userChrome.css customizations for custom background
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// 4. Pin AI tools shortcuts to the New Tab page
user_pref("browser.newtabpage.pinned", '[{"url":"https://chat.openai.com","title":"ChatGPT"},{"url":"https://claude.ai","title":"Claude"},{"url":"https://gemini.google.com","title":"Gemini"},{"url":"https://perplexity.ai","title":"Perplexity"},{"url":"https://poe.com","title":"Poe"},{"url":"https://you.com","title":"You.com"},{"url":"https://huggingface.co/chat","title":"HuggingFace"}]');

// 5. Disable sponsored content and recommended stories
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.stories", false);

// 6. Completely disable Pocket integration
user_pref("extensions.pocket.enabled", false);

// 7. Privacy and security enhancements
user_pref("privacy.trackingprotection.enabled", true);
user_pref("browser.safebrowsing.malware.enabled", true);
user_pref("browser.safebrowsing.phishing.enabled", true);

// 8. Disable telemetry and data collection
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// 9. Performance optimizations
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.sessionstore.restore_on_demand", true);

// 10. Custom new tab page settings
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);
user_pref("browser.newtabpage.activity-stream.topSitesRows", 2);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
