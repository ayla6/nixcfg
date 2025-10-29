{
  lib,
  config,
  ...
}: {
  options.myHome.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.plasma.enable {};
}
