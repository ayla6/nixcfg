{
  lib,
  pkgs,
  ...
}: let
  mkFontOption = name: package:
    lib.mkOption {
      description = "Font definition";
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "The font's name";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = package;
            description = "The font's package";
          };
        };
      };
      default = {};
    };
in {
  options.mySnippets.fonts = lib.mkOption {
    description = "Font configuration";
    type = lib.types.submodule {
      options = {
        sans-serif = mkFontOption "Roboto Flex" pkgs.roboto-flex;

        serif = mkFontOption "Source Serif" pkgs.source-serif;

        monospace = mkFontOption "JetBrainsMono NF" pkgs.nerd-fonts.jetbrains-mono;

        emoji = mkFontOption "Noto Color Emoji" pkgs.noto-fonts-color-emoji;

        pixel = mkFontOption "Cozette" pkgs.cozette;

        size = lib.mkOption {
          description = "Font sizes";
          type = lib.types.submodule {
            options = {
              app = lib.mkOption {
                type = lib.types.int;
                default = 10;
              };
              desktop = lib.mkOption {
                type = lib.types.int;
                default = 10;
              };
            };
          };
          default = {};
        };
      };
    };
    default = {};
  };
}
