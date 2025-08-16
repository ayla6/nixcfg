{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  engines = import ./engines.nix;
in {
  options.myHome.programs.firefox = {
    enable = lib.mkEnableOption "firefox web browser";
    mode = lib.mkOption {
      type = lib.types.enum ["onebar" "sidebar" "default"];
      default = "onebar";
      description = "Firefox UI mode";
    };
  };

  config.programs.firefox = lib.mkMerge [
    (lib.mkIf
      config.myHome.programs.firefox.enable
      {
        enable = true;
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
              keepassxc-browser
              libredirect
              stylus
              violentmonkey
              ublacklist
              steam-database
              snowflake
              sponsorblock
              search-by-image
              ff2mpv
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
      })

    (lib.mkIf
      (config.myHome.programs.firefox.mode == "onebar")
      {
        profiles.default = {
          settings = {
            "onebar.collapse-URLbar" = true;
            "onebar.conditional-navigation-buttons" = false;
            "onebar.hide-all-URLbar-icons" = true;
          };

          userChrome = builtins.readFile self.inputs.firefox-onebar;

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            adaptive-tab-bar-colour
          ];
        };
      })

    (
      if (config.myHome.programs.firefox.mode == "sidebar")
      then {
        profiles.default = {
          settings = {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "sidebar.animation.expand-on-hover.duration-ms" = 50;
            "sidebar.expandOnHover" = false;
            "sidebar.visibility" = "always-show";
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.uidensity" = 0;
          };

          userChrome = ''
            .tab-icon-overlay{ display: none !important; }
          '';
        };
      }
      else {
        profiles.default = {
          settings = {
            "sidebar.revamp" = false;
            "sidebar.verticalTabs" = false;
            "browser.toolbars.bookmarks.visibility" = "newtab";
            "browser.uidensity" = 1;
          };
        };
      }
    )
  ];
}
