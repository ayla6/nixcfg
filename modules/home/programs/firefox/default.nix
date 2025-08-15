{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  engines = import ./engines.nix;
in {
  options.myHome.programs.firefox.enable = lib.mkEnableOption "firefox web browser";

  config = lib.mkIf config.myHome.programs.firefox.enable {
    programs.firefox = {
      enable = true;
      languagePacks = [
        "en-GB"
        "en"
        "en-US"
      ];

      profiles = {
        default = {
          id = 0;
          isDefault = true;

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            consent-o-matic
            ublock-origin
            aria2-integration
            adaptive-tab-bar-colour
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
              "Wikipedia"
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
              "browser.toolbars.bookmarks.visibility" = "newtab";
              "svg.context-properties.content.enabled" = true;
              "browser.uidensity" = 1;
              "general.autoScroll" = true;
              "ui.key.menuAccessKeyFocuses" = false;
              "browser.search.separatePrivateDefault" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

              # OneBar settings
              "onebar.collapse-URLbar" = true;
              "onebar.conditional-navigation-buttons" = false;
              "onebar.hide-all-URLbar-icons" = true;
            };

          userChrome = builtins.readFile self.inputs.firefox-onebar;

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
        test = {
          id = 1;
          isDefault = false;
        };
      };
    };
  };
}
