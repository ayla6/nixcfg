{
  lib,
  config,
  ...
}: {
  options.myHome.programs.anki.enable = lib.mkEnableOption "fastfetch system information";

  config = lib.mkIf config.myHome.programs.anki.enable {
    programs.anki = {
      enable = true;
    };
  };
}
