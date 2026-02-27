{
  config,
  lib,
  ...
}: let
  name = "slskd";
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
    services = {
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port} {
          flush_interval -1
        }
      '';

      slskd = {
        enable = true;
        openFirewall = true;
        domain = null;
        settings = {
          web.port = service.port;
          shares.directories = ["/data/Music" "!/data/Music/Scripts" "!/data/Music/ArtistInfo"];
        };
        environmentFile = config.age.secrets.slskd.path;
      };
    };
  };
}
