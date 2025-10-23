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

    random = lib.mkOption {
      default = true;
      description = "Enable random encryption for swap file.";
      type = lib.types.bool;
    };

    keyFile = lib.mkOption {
      default = "/.swapkey";
      description = "Location of the encryption key.";
      type = lib.types.path;
    };

    blkDev = lib.mkOption {
      default = "/dev/sda1";
      description = "Block device for swap file.";
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.myNixOS.profiles.swap.enable {
    swapDevices = [
      {
        device = config.myNixOS.profiles.swap.location;
        priority = 0;
        randomEncryption.enable = config.myNixOS.profiles.swap.random;
        encrypted = lib.mkIf (!config.myNixOS.profiles.swap.random) {
          label = "swapfile";
          enable = true;
          inherit (config.myNixOS.profiles.swap) keyFile blkDev;
        };
        inherit (config.myNixOS.profiles.swap) size;
      }
    ];
  };
}
