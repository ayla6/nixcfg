{
  config,
  lib,
  ...
}: let
  name = "navidrome";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
  publicNetwork = config.mySnippets.aylac-top;
  publicService = publicNetwork.networkMap.${name};
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
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      cloudflared.tunnels."${publicNetwork.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${publicService.vHost}" = "http://${publicService.hostName}:${toString service.port}";
      };

      navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          MusicFolder = "/data/Music";
          Address = "0.0.0.0";
          Port = service.port;
          AuthRequestLimit = 5;
          AuthWindowLength = "10m";
          EnableSharing = true;
        };
        environmentFile = config.age.secrets.navidrome.path;
      };
    };
  };
}
