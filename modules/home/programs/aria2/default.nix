{
  lib,
  config,
  ...
}: {
  options.myHome.services.aria2.enable = lib.mkEnableOption "aria2 downloader";

  config = lib.mkIf config.myHome.services.aria2.enable {
    programs.aria2 = {
      enable = true;
      settings = {
        dir = "~/Downloads";
      };
    };
  };
}
