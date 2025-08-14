{
  config,
  lib,
  ...
}: {
  options.myHardware.lenovo.ideapad."320-14IKB".enable =
    lib.mkEnableOption "Configuration for the Lenovo ideapad 320-14IKB.";

  config = lib.mkIf config.myHardware.lenovo.ideapad."320-14IKB".enable {
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
