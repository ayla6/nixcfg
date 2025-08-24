{
  config,
  lib,
  self,
  ...
}: let
  name = "vaultwarden";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.aylac-top;
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
    age.secrets.vaultwarden.file = "${self.inputs.secrets}/vaultwarden.age";

    services = {
      cloudflared.tunnels."${network.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = "http://${service.hostName}:${toString service.port}";
      };

      vaultwarden = {
        enable = true;

        config = {
          DOMAIN = "https://${service.vHost}";
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_LOG = "critical";
          ROCKET_PORT = service.port;
          SIGNUPS_ALLOWED = false;
          ICON_SERVICE = "bitwarden";
          ICON_CACHE_TTL = 0;
          IP_HEADER = "CF-Connecting-IP";
        };

        environmentFile = config.age.secrets.vaultwarden.path;
      };
    };
  };
}
