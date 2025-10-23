{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.base.enable = lib.mkEnableOption "Base common hardware configuration";

  config = lib.mkIf config.myHardware.profiles.base.enable {
    console.useXkbConfig = true;

    hardware = {
      enableAllFirmware = true;

      bluetooth = {
        enable = false;
        powerOnBoot = true;
      };

      keyboard.qmk.enable = true;
    };

    services = {
      fstrim.enable = true;

      logind.settings.Login = {
        HandlePowerKey = lib.mkDefault "suspend";
        HandlePowerKeyLongPress = lib.mkDefault "poweroff";
      };

      xserver.xkb = {
        layout = "us";
        variant = "colemak";
      };
    };

    zramSwap.enable = lib.mkDefault true;
  };
}
