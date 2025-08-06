let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs = {
    firefox = {
      enable = true;
      languagePacks = [
        "nl"
        "en-US"
      ];

      # Configurations which can't be set using policies
      autoConfig = ''
        pref("mousewheel.min_line_scroll_amount", 180);
        pref("mousewheel.default.delta_multiplier_x", 30);
        pref("mousewheel.default.delta_multiplier_y", 30);
      '';

      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"

        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Tab Shortcuts
          "{1125aee3-7a78-469d-8099-f9bc57c9c014}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-shortcuts-2zqa/latest.xpi";
            installation_mode = "force_installed";
          };
          "keyhub@topicus.nl" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/topicus-keyhub/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        # Check about:config for options.
        Preferences = {
          "general.autoScroll" = lock-true;
          "browser.contentblocking.category" = {
            Value = "strict";
            Status = "locked";
          };
          "extensions.pocket.enabled" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "dom.text_fragments.create_text_fragment.enabled" = lock-true;
        };
      };
    };
  };
}
