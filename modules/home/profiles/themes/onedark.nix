{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.myHome.profiles.theme == "onedark") {
    programs.zellij.settings.theme = "onedark";
    programs.helix.settings.theme = "zed_onedark";

    myHome.profiles.colours = {
      foreground = "#c8ccd4";
      background = "#282c33";

      black = "#282c33";
      red = "#d07277";
      green = "#a1c181";
      yellow = "#dfc184";
      blue = "#73ade9";
      magenta = "#b477cf";
      cyan = "#6eb4bf";
      white = "#dce0e5";

      grey = "#525561";

      br_red = "#eab7b9";
      br_green = "#d1e0bf";
      br_yellow = "#f1dfc1";
      br_blue = "#bed5f4";
      br_magenta = "#d6b4e4";
      br_cyan = "#b9d9df";
      br_white = "#fafafa";

      dim_black = "#dce0e5";
      dim_red = "#673a3c";
      dim_green = "#4d6140";
      dim_yellow = "#e5c07b";
      dim_blue = "#385378";
      dim_magenta = "#612a79";
      dim_cyan = "#3a565b";
      dim_white = "#575d65";
    };
  };
}
