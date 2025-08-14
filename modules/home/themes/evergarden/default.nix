{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [inputs.evergarden.homeManagerModules.default];

  options.myHome.themes.evergarden.enable = lib.mkEnableOption "enable the evergarden theme";

  config = lib.mkIf config.myHome.themes.evergarden.enable {
    evergarden = {
      enable = true;
      variant = "winter";
      accent = "pink";
    };
  };
}
