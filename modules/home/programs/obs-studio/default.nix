{
  lib,
  config,
  ...
}: {
  options.myHome.programs.obs-studio.enable = lib.mkEnableOption "obs studio";

  config = lib.mkIf config.myHome.programs.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
