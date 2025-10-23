{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.hibernation = {
    enable = lib.mkEnableOption "enable hibernation";
    swap = {
      size = lib.mkOption {
        default = 0;
        description = "Swap size in megabytes.";
        type = lib.types.int;
      };

      location = lib.mkOption {
        default = "/.swap";
        description = "Swap file location.";
        type = lib.types.path;
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
  };

  config = lib.mkIf (config.myNixOS.profiles.hibernation.enable && config.myNixOS.profiles.hibernation.swap.size > 0) {
    myNixOS.profiles.swap = {
      enable = true;
      random = false;
      inherit (config.myNixOS.profiles.hibernation.swap) size location keyFile blkDev;
    };

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
    };

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=15m
      AllowSuspendThenHibernate=yes
      HibernateOnACPower=no
    '';
  };
}
