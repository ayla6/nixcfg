{
  pkgs,
  lib,
  config,
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
      ];

      protonPackages = with pkgs; [proton-ge-bin];
      winePackages = with pkgs; [wineWow64Packages.waylandFull];
    };
  };
}
