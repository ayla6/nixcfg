{
  pkgs,
  lib,
  config,
  ...
}: let
  engines = import ./engines.nix;
in {
  options.mySnippets.firefox-based = {
    policies = lib.mkOption {
      type = lib.types.attrs;
      description = "Policies for Firefox-based browsers";
      default = {
        Cookies.Behavior = "reject-foreign";
        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "newtab";
        #DisableFirefoxAccounts = true;
        DisableSafeMode = true;

        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;

        HttpsOnlyMode = "enabled";

        DNSOverHTTPS = {
          Enabled = true;
          Fallback = true;
        };

        DontCheckDefaultBrowser = true;

        EnableTrackingProtection = {
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          Locked = false;
          Value = true;
        };

        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = false;
        };

        FirefoxHome = {
          Highlights = false;
          Locked = false;
          Pocket = false;
          Search = true;
          Snippets = false;
          SponsoredPocket = false;
          SponsoredTopSites = false;
          TopSites = false;
        };

        FirefoxSuggest = {
          ImproveSuggest = false;
          Locked = false;
          SponsoredSuggestions = false;
          WebSuggestions = false;
        };

        HardwareAcceleration = true;

        Homepage = {
          Locked = false;
          StartPage = "previous-session";
        };

        NewTabPage = false;
        NoDefaultBookmarks = true; # Enabling this prevents declaratively setting bookmarks.
        OfferToSaveLoginsDefault = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";

        PDFjs = {
          Enabled = true;
          EnablePermissions = false;
        };

        Preferences = {
          # Do not add the extra "Import Bookmarks" button in the bookmarks interface
          "browser.bookmarks.addedImportButton" = false;

          # Mark that the user has accepted the data reporting (telemetry) policy
          "datareporting.policy.dataSubmissionPolicyAccepted" = false;

          # Allow extensions from all scopes (profile, system, etc.) without auto-disabling them
          "extensions.autoDisableScopes" = 0;

          # Enable VA-API hardware video decoding via FFmpeg (useful on Linux systems)
          "media.ffmpeg.vaapi.enabled" = true;

          # Enable the VP8/VP9 media data decoder, used in WebRTC and video playback
          "media.navigator.mediadatadecoder_vpx_enabled" = true;

          # Enable the Remote Data Decoder (RDD) process for FFmpeg to isolate media decoding tasks
          "media.rdd-ffmpeg.enabled" = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };

        UseSystemPrintDialog = true;
      };
    };

    userConfig = lib.mkOption {
      type = lib.types.attrs;
      description = "My config for Firefox-based browsers";
      default = {
        enable = true;

        inherit (config.mySnippets.firefox-based) policies;

        #nativeMessagingHosts = lib.optionals pkgs.stdenv.isLinux [pkgs.bitwarden-desktop];
        languagePacks = [
          "en-GB"
          "en"
          "en-US"
        ];

        # this for some reason doesn't work neither here nor in /modules/nixos/programs/firefox, but i'm keeping it here so i can remember to install those manually again if i ever need to
        # policies = {
        #   ExtensionSettings = {
        #     "magnolia@12.34" = {
        #       default_area = "menupanel";
        #       install_url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_cle# an-latest.xpi";
        #       installation_mode = "normal_installed";
        #     };
        #     "pt-BR@dictionaries.addons.mozilla.org" = {
        #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/corretor/latest.xpi";
        #       installation_mode = "normal_installed";
        #     };
        #   };
        # };

        profiles = {
          default = {
            id = 0;
            isDefault = true;

            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              consent-o-matic
              ublock-origin
              aria2-integration
              #keepassxc-browser
              libredirect
              stylus
              violentmonkey
              ublacklist
              steam-database
              snowflake
              sponsorblock
              karakeep
              bitwarden
            ];

            search = {
              inherit engines;
              default = "Unduck";
              force = true;

              order = [
                "Unduck"
                "Home Manager Options"
                "NixOS Wiki"
                "nixpkgs"
                "wikipedia"
                "Wiktionary"
              ];
            };

            settings =
              (import ./betterfox/fastfox.nix)
              // (import ./betterfox/peskyfox.nix)
              // (import ./betterfox/securefox.nix)
              // (import ./betterfox/smoothfox.nix)
              // {
                "browser.tabs.groups.enabled" = true;
                "browser.tabs.groups.smart.enabled" = true;
                "svg.context-properties.content.enabled" = true;
                "general.autoScroll" = true;
                "ui.key.menuAccessKeyFocuses" = false;
                "browser.search.separatePrivateDefault" = false;
                "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
                "browser.ml.chat.sidebar" = false;
              };

            userContent = ''
              @font-face {
                  font-family: "Segoe UI";
                  src: url("${pkgs.roboto-flex}/share/fonts/truetype/RobotoFlex[GRAD,XOPQ,XTRA,YOPQ,YTAS,YTDE,YTFI,YTLC,YTUC,opsz,slnt,wdth,wght].ttf");
              }
              @font-face {
                  font-family: "system-ui";
                  src: url("${pkgs.roboto-flex}/share/fonts/truetype/RobotoFlex[GRAD,XOPQ,XTRA,YOPQ,YTAS,YTDE,YTFI,YTLC,YTUC,opsz,slnt,wdth,wght].ttf");
              }
              @font-face {
                  font-family: "-apple-system";
                  src: url("${pkgs.roboto-flex}/share/fonts/truetype/RobotoFlex[GRAD,XOPQ,XTRA,YOPQ,YTAS,YTDE,YTFI,YTLC,YTUC,opsz,slnt,wdth,wght].ttf");
              }
              @font-face {
                  font-family: "BlinkMacSystemFont";
                  src: url("${pkgs.roboto-flex}/share/fonts/truetype/RobotoFlex[GRAD,XOPQ,XTRA,YOPQ,YTAS,YTDE,YTFI,YTLC,YTUC,opsz,slnt,wdth,wght].ttf");
              }
            '';
          };
        };
      };
    };
  };
}
