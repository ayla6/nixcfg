{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  options.myHome.programs.lutris.enable = lib.mkEnableOption "lutris";

  config = lib.mkIf config.myHome.programs.lutris.enable {
    programs.lutris = {
      enable = true;

      extraPackages = with pkgs; [
        mangohud
        winetricks
        gamescope
        umu-launcher
        wineWow64Packages.waylandFull
      ];

      steamPackage = osConfig.programs.steam.package;
    };
  };
}
