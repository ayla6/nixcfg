{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.ghostty.enable = lib.mkEnableOption "ghostty terminal emulator";

  config = lib.mkIf config.myHome.programs.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;
      enableFishIntegration = true;
      systemd.enable = true;

      settings = lib.mkIf pkgs.stdenv.isLinux {
        theme = "Adwaita Dark";
        font-family = "JetBrainsMono NF";
        font-style = "Semibold";
        font-feature = "calt";
        font-size = 9;
      };
    };
  };
}
