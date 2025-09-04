# for the pds-gatekeeper https://tangled.sh/@isabelroses.com/dotfiles/blob/61ad925dc8b4537b568784971589b137df5cb948/modules/nixos/services/pds.nix
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  name = "pds";
  cfg = config.myNixOS.services.${name};

  gk = config.containers.pds.config.services.pds-gatekeeper.settings;
  gkurl = "http://${gk.GATEKEEPER_HOST}:${toString gk.GATEKEEPER_PORT}";

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

        # https://gist.github.com/mary-ext/6e27b24a83838202908808ad528b3318
        handle /xrpc/app.bsky.unspecced.getAgeAssuranceState {
        	header content-type "application/json"
        	header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy"
        	header access-control-allow-origin "*"
        	respond `{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured"}` 200
        }

        # hijack the links for pds-gatekeeper
        #@gatekeeper {
        #  path /xrpc/com.atproto.server.getSession
        #  path /xrpc/com.atproto.server.updateEmail
        #  path /xrpc/com.atproto.server.createSession
        #  path /@atproto/oauth-provider/~api/sign-in
        #}

        #handle @gatekeeper {
        #  reverse_proxy ${gkurl}
        #}

        handle {
          reverse_proxy ${service.hostName}:${toString service.port}
        }
      '';
    };

    containers.pds = {
      autoStart = true;
      bindMounts."${config.age.secrets.pds.path}".isReadOnly = true;
      config = {
        imports = [self.inputs.tgirlpkgs.nixosModules.default];

        services = {
          bluesky-pds = {
            enable = true;
            environmentFiles = [config.age.secrets.pds.path];
            pdsadmin.enable = true;
            settings = {
              PDS_HOSTNAME = service.vHost;
              PDS_PORT = service.port;
              # PDS_BSKY_APP_VIEW_URL = "https://bsky.zeppelin.social";
              # PDS_BSKY_APP_VIEW_DID = "did:web:bsky.zeppelin.social";

              # crawlers taken from the following post
              # <https://bsky.app/profile/billy.wales/post/3lxpd67hnks2e>
              PDS_CRAWLERS = lib.concatStringsSep "," [
                "https://bsky.network"
                "https://relay.cerulea.blue"
                "https://relay.fire.hose.cam"
                "https://relay2.fire.hose.cam"
                "https://relay3.fr.hose.cam"
                "https://relay.hayescmd.net"
              ];
            };
          };

          pds-gatekeeper = {
            enable = false;
            # we need to share a lot of secrets between pds and gatekeeper
            environmentFiles = [config.age.secrets.pds.path];

            settings = {
              GATEKEEPER_PORT = 3602;
              PDS_BASE_URL = "http://${service.hostName}:${toString service.port}";
              GATEKEEPER_TRUST_PROXY = "true";

              # make an empty file to prevent early errors due to no pds env
              # it really wants to load this file but with nix we don't really do it that way
              PDS_ENV_LOCATION = toString (pkgs.writeText "gatekeeper-pds-env" "");
            };
          };
        };

        system.stateVersion = "25.11";
      };
    };
  };
}
