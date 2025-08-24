{
  config,
  lib,
  ...
}: let
  name = "ntfy";
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
    services = {
      cloudflared.tunnels."${network.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = "http://${service.hostName}:${toString service.port}";
      };

      ntfy-sh = {
        enable = true;
        user = "ntfy";
        group = "ntfy";
        settings = {
          listen-http = ":${toString service.port}";
          base-url = "https://${service.vHost}";
          cache-duration = "30d";
          cache-startup-queries = ''
            pragma journal_mode = WAL;
            pragma synchronous = normal;
            pragma temp_store = memory;
          '';
          behind-proxy = true;
          auth-default-access = "deny-all";
          auth-users = [
            "ayla:$2a$10$hh05DMOuVQ3Zf67Rn8VUl.HYUop/.90V04IhNPmOsSYh9FSHCbL1K:admin"
            "auto:$2a$10$w7EDB/6orrpM9JVBqu4jHeBKvXliA4jvRI7Nd.fn.Fo4rGTHD50ju:user"
          ];
          auth-access = [
            "everyone:up*:wo"
            "auto:*:wo"
            "everyone:message-to-ayla:wo"
          ];
        };
      };
    };
  };
}
