{
  config,
  lib,
  ...
}: let
  name = "redlib";
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
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      redlib = {
        enable = true;
        openFirewall = false;
        inherit (service) port;
        settings = {
          ENABLE_RSS = "on";
          REDLIB_DEFAULT_SHOW_NSFW = "on";
          REDLIB_DEFAULT_USE_HLS = "on";
          FULL_URL = "https://${service.vHost}";
        };
      };
    };
  };
}
