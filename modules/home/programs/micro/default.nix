{
  lib,
  config,
  ...
}: {
  options.myHome.programs.micro.enable = lib.mkEnableOption "micro editor";

  config = lib.mkIf config.myHome.programs.micro.enable {
    programs.micro = {
      enable = true;
      settings = {
        colorscheme = "simple";
        mkparents = true;
        scrollspeed = 1;
        tabsize = 2;
        tabstospaces = true;
      };
    };
  };
}
