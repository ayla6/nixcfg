{
  config,
  lib,
  ...
}: {
  options.myHardware.acer.aspire.A515-52G.enable =
    lib.mkEnableOption "Acer Aspire A515-52G hardware configuration.";

  config = lib.mkIf config.myHardware.acer.aspire.A515-52G.enable {
    home-manager = {
      sharedModules = [
        {
          services.easyeffects = {
            enable = true;
            # yeah i literally just got aly's t440p's config i have no idea if they're similar in how they suck but mine do suck
            preset = "T440p.json";
          };

          xdg.configFile."easyeffects/output/T440p.json".source = ./easyeffects.json;
        }
      ];
    };

    hardware.nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    myHardware = {
      nvidia.gpu.enable = true;
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
