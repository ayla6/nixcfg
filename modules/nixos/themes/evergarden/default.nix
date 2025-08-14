{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [inputs.evergarden.nixosModules.evergarden];

  options.myNixOS.themes.evergarden.enable = lib.mkEnableOption "enable the evergarden theme";

  config = lib.mkIf config.myNixOS.themes.evergarden.enable {
    evergarden = {
      enable = true;
      variant = "winter";
      accent = "pink";
    };
  };
}
