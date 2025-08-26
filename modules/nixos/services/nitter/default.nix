{
  config,
  lib,
  ...
}: let
  name = "nitter";
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

      nitter = {
        enable = true;
        openFirewall = true;
        server = {
          title = "twotter";
          inherit (service) port;
          hostname = "${config.mySnippets.tailnet.networkMap.redlib.vHost}";
        };
        preferences = {
          theme = "Twitter";
          squareAvatars = true;
          replaceTwitter = "${service.vHost}";
          replaceReddit = "${config.mySnippets.tailnet.networkMap.redlib.vHost}";
          proxyVideos = false;
          infiniteScroll = true;
          hlsPlayback = true;
        };
      };
    };
  };
}
