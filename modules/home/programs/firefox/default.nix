{
  lib,
  config,
  #pkgs,
  #self,
  ...
}: {
  options.myHome.programs.firefox = {
    enable = lib.mkEnableOption "firefox web browser";
    mode = lib.mkOption {
      type = lib.types.enum ["sidebar" "default"];
      default = "sidebar";
      description = "Firefox UI mode";
    };
  };

  config.programs.firefox = lib.mkMerge [
    (
      lib.mkIf
      config.myHome.programs.firefox.enable
      config.mySnippets.firefox-based.userConfig
    )

    #(lib.mkIf
    #  (config.myHome.programs.firefox.mode == "onebar")
    #  {
    #    profiles.default = {
    #      settings = {
    #        "onebar.collapse-URLbar" = true;
    #        "onebar.conditional-navigation-buttons" = false;
    #        "onebar.hide-all-URLbar-icons" = true;
    #      };
    #
    #      userChrome = builtins.readFile self.inputs.firefox-onebar;
    #
    #      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
    #        adaptive-tab-bar-colour
    #      ];
    #    };
    #  })

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
