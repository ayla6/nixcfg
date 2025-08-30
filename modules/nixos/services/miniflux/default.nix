{
  config,
  lib,
  self,
  ...
}: let
  name = "miniflux";
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
    age.secrets = {
      miniflux.file = "${self.inputs.secrets}/miniflux.age";
      postgresMiniflux.file = "${self.inputs.secrets}/postgres/miniflux.age";
    };

    myNixOS.services.postgresql = {
      enable = true;
      databases = ["miniflux"];
    };

    services = {
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      miniflux = {
        enable = true;
        adminCredentialsFile = config.age.secrets.miniflux.path;
        createDatabaseLocally = false;
        config = {
          BATCH_SIZE = 100;
          CLEANUP_FREQUENCY_HOURS = 48;
          LISTEN_ADDR = "${service.hostName}:${toString service.port}";
          BASE_URL = "https://${service.vHost}";
          DATABASE_URL = ''user=miniflux dbname=miniflux sslmode=disable'';
        };
      };
    };
  };
}
