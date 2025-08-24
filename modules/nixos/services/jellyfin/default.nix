{
  config,
  lib,
  ...
}: let
  name = "jellyfin";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};

  dataDirectory = "/var/lib";
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
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port} {
          flush_interval -1
        }
      '';

      jellyfin = {
        enable = true;
        openFirewall = true;
        dataDir = "${dataDirectory}/jellyfin";
      };
    };
  };
}
