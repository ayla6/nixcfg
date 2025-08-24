{
  config,
  self,
  lib,
  ...
}: let
  name = "copyparty";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name} server";
    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.copyparty = {
      file = "${self.inputs.secrets}/copyparty.age";
      owner = "copyparty";
      group = "copyparty";
      mode = "0400";
    };

    services = {
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      copyparty = {
        enable = true;
        settings = {
          i = "0.0.0.0";
          p = [service.port (service.port + 1)];
          no-reload = true;
          ignored-flag = false;
        };
        accounts = {
          ayla = {
            passwordFile = config.age.secrets.copyparty.path;
          };
        };
        volumes = {
          "/" = {
            path = "/data/copyparty";
            access = {
              r = ["*"];
              A = ["ayla"];
            };
            flags = {
              fk = 4;
              scan = 480;
            };
          };
        };
      };
    };
  };
}
