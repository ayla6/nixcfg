{
  lib,
  pkgs,
  ...
}: {
  options.mySnippets.fonts = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Editor configuration data";
  };

  config.mySnippets.fonts = {
    sans-serif = {
      name = "Roboto Flex";
      package = pkgs.roboto-flex;
    };
    serif = {
      name = "Source Serif";
      package = pkgs.source-serif;
    };
    monospace = {
      name = "JetBrainsMono NF";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };

    sizes = {
      applications = 10;
      desktop = 10;
    };
  };
}
