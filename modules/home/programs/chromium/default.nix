# https://github.com/isabelroses/dotfiles/blob/ed6d3765ffb7dcfe67540f111f23d51a0d9617d5/modules/home/programs/chromium.nix#L16
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatLists
    concatMapStrings
    enableFeature
    ;
in {
  options.myHome.programs.chromium.enable = lib.mkEnableOption "chromium web browser";

  config = lib.mkIf config.myHome.programs.chromium.enable {
    programs.chromium = {
      enable = true;

      package = pkgs.ungoogled-chromium.override {
        enableWideVine = true;

        # https://github.com/secureblue/hardened-chromium
        # https://github.com/secureblue/secureblue/blob/e500f078efc5748d5033a881bbbcdcd2de95a813/files/system/usr/etc/chromium/chromium.conf.md
        commandLineArgs = concatLists [
          # Aesthetics
          [
            "--gtk-version=4"
          ]

          # Wayland
          [
            "--ozone-platform=wayland"
            "--enable-features=UseOzonePlatform"
          ]

          # Etc
          [
            "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
            (enableFeature false "reading-from-canvas")
            "--no-first-run"
            "--disable-wake-on-wifi"
            "--disable-breakpad"

            # please stop asking me to be the default browser
            "--no-default-browser-check"

            # I don't need these, thus I disable them
            (enableFeature false "speech-api")
            (enableFeature false "speech-synthesis-api")
          ]

          # Security
          [
            # Disable pings
            "--no-pings"
            # Require HTTPS for component updater
            "--component-updater=require_encryption"
            # Disable crash upload
            "--no-crash-upload"
            # don't run things without asking
            "--no-service-autorun"
            # Disable sync
            "--disable-sync"

            (
              "--enable-features="
              + concatMapStrings (x: x + ",") [
                # Enable visited link database partitioning
                "PartitionVisitedLinkDatabase"
                # Enable prefetch privacy changes
                "PrefetchPrivacyChanges"
                # Enable split cache
                "SplitCacheByNetworkIsolationKey"
                "SplitCodeCacheByNetworkIsolationKey"
                # Enable partitioning connections
                "EnableCrossSiteFlagNetworkIsolationKey"
                "HttpCacheKeyingExperimentControlGroup"
                "PartitionConnectionsByNetworkIsolationKey"
                # Enable strict origin isolation
                "StrictOriginIsolation"
                # Enable reduce accept language header
                "ReduceAcceptLanguage"
                # Enable content settings partitioning
                "ContentSettingsPartitioning"
                # i like moving pages with my touchpad...
                "TouchpadOverscrollHistoryNavigation"
              ]
            )

            (
              "--disable-features="
              + concatMapStrings (x: x + ",") [
                # Disable autofill
                "AutofillPaymentCardBenefits"
                "AutofillPaymentCvcStorage"
                "AutofillPaymentCardBenefits"
                # Disable third-party cookie deprecation bypasses
                "TpcdHeuristicsGrants"
                "TpcdMetadataGrants"
                # Disable hyperlink auditing
                "EnableHyperlinkAuditing"
                # Disable showing popular sites
                "NTPPopularSitesBakedInContent"
                "UsePopularSitesSuggestions"
                # Disable article suggestions
                "EnableSnippets"
                "ArticlesListVisible"
                "EnableSnippetsByDse"
                # Disable content feed suggestions
                "InterestFeedV2"
                # Disable media DRM preprovisioning
                "MediaDrmPreprovisioning"
                # Disable autofill server communication
                "AutofillServerCommunication"
                # Disable new privacy sandbox features
                "PrivacySandboxSettings4"
                "BrowsingTopics"
                "BrowsingTopicsDocumentAPI"
                "BrowsingTopicsParameters"
                # Disable translate button
                "AdaptiveButtonInTopToolbarTranslate"
                # Disable detailed language settings
                "DetailedLanguageSettings"
                # Disable fetching optimization guides
                "OptimizationHintsFetching"
                # Partition third-party storage
                "DisableThirdPartyStoragePartitioningDeprecationTrial2"

                # Disable media engagement
                "PreloadMediaEngagementData"
                "MediaEngagementBypassAutoplayPolicies"
              ]
            )
          ]
        ];
      };
    };
  };
}
