{
  lib,
  config,
  ...
}: {
  options.myHome.services.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf config.myHome.services.syncthing.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
