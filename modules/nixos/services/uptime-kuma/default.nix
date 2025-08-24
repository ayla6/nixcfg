{
  config,
  lib,
  ...
}: let
  name = "uptime-kuma";
  cfg = config.myNixOS.services.${name};

  inherit (config.mySnippets) aylac-top;
  inherit (config.mySnippets) tailnet;

  publicNetwork = aylac-top;
  privateNetwork = tailnet;
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name} server";
    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
    publicProxy = lib.mkOption {
      default = "caddy";
      example = "cf";
      description = "Public proxy provider for ${name}";
      type = lib.types.enum ["none" "cf" "caddy"];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      caddy.virtualHosts = {
        "${privateNetwork.networkMap.${name}.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
          bind tailscale/${name}
          encode zstd gzip
          reverse_proxy ${privateNetwork.networkMap.${name}.hostName}:${toString privateNetwork.networkMap.${name}.port}
        '';

        "${publicNetwork.networkMap.${name}.vHost}" = lib.mkIf (cfg.publicProxy == "caddy") {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${publicNetwork.networkMap.${name}.hostName}:${toString publicNetwork.networkMap.${name}.port}
          '';
        };
      };

      cloudflared.tunnels."${publicNetwork.cloudflareTunnel}".ingress = lib.mkIf (cfg.publicProxy == "cf") {
        "${publicNetwork.networkMap.pds.vHost}" = "http://${publicNetwork.networkMap.pds.hostName}";
      };

      uptime-kuma = {
        enable = true;
        appriseSupport = true;

        settings = {
          PORT = toString publicNetwork.networkMap.${name}.port;
          HOST = "0.0.0.0";
        };
      };
    };
  };
}
