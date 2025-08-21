{
  config,
  lib,
  ...
}: {
  options.myHardware.acer.aspire."A315-53".enable =
    lib.mkEnableOption "Configuration for the Acer Aspire A315-53.";

  config = lib.mkIf config.myHardware.acer.aspire."A315-53".enable {
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
