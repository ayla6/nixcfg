{
  config,
  lib,
  ...
}: {
  options.myHardware.profiles.laptop.enable = lib.mkEnableOption "Laptop hardware configuration.";

  config = lib.mkMerge [
    (lib.mkIf config.myHardware.profiles.laptop.enable {
      boot.kernel.sysctl."kernel.nmi_watchdog" = lib.mkDefault 0;

      services = {
        tuned = {
          enable = lib.mkDefault true;
          settings.dynamic_tuning = true;
        };

        # udev.extraRules = lib.mkIf config.services.power-profiles-daemon.enable ''
        #   ## Automatically switch power profiles based on AC power status.
        #   ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", RUN+="${lib.getExe pkgs.power-profiles-daemon} set power-saver"
        #   ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", RUN+="${lib.getExe pkgs.power-profiles-daemon} set balanced"
        # '';

        upower.enable = true;
      };
    })

    (lib.mkIf (config.myHardware.intel.cpu.enable && config.myHardware.profiles.laptop.enable) {
      # powerManagement.powertop.enable = true;
      services.thermald.enable = true;
    })
  ];
}
