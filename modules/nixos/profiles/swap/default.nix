{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.swap = {
    enable = lib.mkEnableOption "swap file";

    size = lib.mkOption {
      default = 8192;
      description = "Swap size in megabytes.";
      type = lib.types.int;
    };

    location = lib.mkOption {
      default = "/.swap";
      description = "Swap file location.";
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.myNixOS.profiles.swap.enable {
    swapDevices = [
      {
        device = config.myNixOS.profiles.swap.location;
        priority = 0;
        randomEncryption.enable = true;
        inherit (config.myNixOS.profiles.swap) size;
      }
    ];
  };
}
