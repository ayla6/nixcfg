{
  lib,
  config,
  ...
}: {
  options.myHome.programs.fastfetch.enable = lib.mkEnableOption "fastfetch system information";

  config = lib.mkIf config.myHome.programs.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
