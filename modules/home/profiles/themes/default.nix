{lib, ...}: let
  hexColor = lib.types.strMatching "#[0-9a-fA-F]{6}";

  mkBase = default:
    lib.mkOption {
      type = hexColor;
      inherit default;
      description = "Color";
    };

  mkAlias = inheritance:
    lib.mkOption {
      type = hexColor;
      default = inheritance;
      description = "Color";
    };

  mkBaseOptional = lib.mkOption {
    type = lib.types.nullOr hexColor;
    default = null;
    description = "Optional color";
  };

  mkAliasOptional = inheritance:
    lib.mkOption {
      type = lib.types.nullOr hexColor;
      default = inheritance;
      description = "Optional color";
    };
in {
  imports = [
    ./onedark.nix
    ./agatha.nix
  ];

  options.myHome.profiles.theme = lib.mkOption {
    type = lib.types.enum ["none" "onedark" "agatha"];
    default = "agatha";
    description = "set your theme for a bunch of apps at once!";
  };

  options.myHome.profiles.colours = lib.mkOption {
    description = "Colours defined by the theme";

    type = lib.types.submodule ({config, ...}:
      with config; {
        options = {
          foreground = mkAlias white;
          background = mkAlias black;

          black = mkBase "#000000";
          red = mkBase "#ff0000";
          green = mkBase "#00ff00";
          yellow = mkBase "#ffff00";
          blue = mkBase "#0000ff";
          magenta = mkBase "#ff00ff";
          cyan = mkBase "#00ffff";
          white = mkBase "#ffffff";
          grey = mkBase "#555555";

          br_black = mkAlias grey;
          br_red = mkBase "#ff8888";
          br_green = mkBase "#88ff88";
          br_yellow = mkBase "#ffff88";
          br_blue = mkBase "#8888ff";
          br_magenta = mkBase "#ff88ff";
          br_cyan = mkBase "#88ffff";
          br_white = mkBase "#ffffff";

          dim_black = mkBaseOptional;
          dim_red = mkBaseOptional;
          dim_green = mkBaseOptional;
          dim_yellow = mkBaseOptional;
          dim_blue = mkBaseOptional;
          dim_magenta = mkBaseOptional;
          dim_cyan = mkBaseOptional;
          dim_white = mkBaseOptional;

          regular0 = mkAlias black;
          regular1 = mkAlias red;
          regular2 = mkAlias green;
          regular3 = mkAlias yellow;
          regular4 = mkAlias blue;
          regular5 = mkAlias magenta;
          regular6 = mkAlias cyan;
          regular7 = mkAlias white;

          bright0 = mkAlias br_black;
          bright1 = mkAlias br_red;
          bright2 = mkAlias br_green;
          bright3 = mkAlias br_yellow;
          bright4 = mkAlias br_blue;
          bright5 = mkAlias br_magenta;
          bright6 = mkAlias br_cyan;
          bright7 = mkAlias br_white;

          dim0 = mkAliasOptional dim_black;
          dim1 = mkAliasOptional dim_red;
          dim2 = mkAliasOptional dim_green;
          dim3 = mkAliasOptional dim_yellow;
          dim4 = mkAliasOptional dim_blue;
          dim5 = mkAliasOptional dim_magenta;
          dim6 = mkAliasOptional dim_cyan;
          dim7 = mkAliasOptional dim_white;
        };
      });
  };
}
