{
  config,
  lib,
  ...
}: {
  options.myHardware.hp.theRedOne.enable =
    lib.mkEnableOption "The Red HP laptop hardware configuration.";

  config = lib.mkIf config.myHardware.hp.theRedOne.enable {
    myHardware = {
      intel = {
        cpu.enable = true;
        gpu.enable = true;
      };

      profiles = {
        base.enable = true;
        laptop.enable = true;
      };
    };
  };
}
