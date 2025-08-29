{
  config,
  lib,
  ...
}: let
  name = "pds";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.aylac-top;
  service = network.networkMap.${name};

  pdsHomePage = ''
    hiii this is an ATProto PDS!! You will find my (ayla) account here!!
    i should probably put some cool ass art in here or maybe an actual homepage
    but having this by itself is fun

    most API routes are under /xrpc/
  '';
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "atproto pds";
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
        "${service.vHost}" = "http://${service.hostName}";
      };

      caddy.virtualHosts."http://${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        encode zstd gzip

        handle / {
          respond "${pdsHomePage}"
        }

        handle /xrpc/app.bsky.unspecced.getAgeAssuranceState {
        	header content-type "application/json"
        	header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy"
        	header access-control-allow-origin "*"
        	respond `{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured"}` 200
        }

        handle {
          reverse_proxy ${service.hostName}:${toString service.port}
        }
      '';

      bluesky-pds = {
        enable = true;
        environmentFiles = [config.age.secrets.pds.path];
        pdsadmin.enable = true;
        settings = {
          PDS_HOSTNAME = service.vHost;
          # PDS_BSKY_APP_VIEW_URL = "https://bsky.zeppelin.social";
          # PDS_BSKY_APP_VIEW_DID = "did:web:bsky.zeppelin.social";
        };
      };
    };
  };
}
