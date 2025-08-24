{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.autoUpgrade = {
    enable = lib.mkEnableOption "auto-upgrade system";

    operation = lib.mkOption {
      type = lib.types.str;
      default = "boot";
      description = "Operation to perform on auto-upgrade. Can be 'boot', 'switch', or 'test'.";
    };

    allowReboot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow auto-upgrade to reboot the system.";
    };
  };

  config = lib.mkIf config.myNixOS.profiles.autoUpgrade.enable {
    system.autoUpgrade = {
      inherit (config.myNixOS.profiles.autoUpgrade) operation;

      enable = true;
      inherit (config.myNixOS.profiles.autoUpgrade) allowReboot;
      dates = "02:00";
      flags = ["--accept-flake-config"];
      flake = config.environment.variables.FLAKE or "github:ayla6/nixcfg";
      persistent = true;
      randomizedDelaySec = "120min";

      rebootWindow = {
        lower = "02:00";
        upper = "06:00";
      };
    };

    # Allow nixos-upgrade to restart on failure (e.g. when laptop wakes up before network connection is set)
    systemd.services.nixos-upgrade = {
      preStart = "${pkgs.host}/bin/host cloudflare.com"; # Check network connectivity

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "120";
      };

      unitConfig = {
        StartLimitIntervalSec = 600;
        StartLimitBurst = 2;
      };
    };
  };
}
