{
  config,
  pkgs,
  ...
}: let
  dataDirectory = "/var/lib";

  mkCaddyVHosts = services:
    pkgs.lib.listToAttrs (map (service: let
      netMap = config.mySnippets.${service.location or "tailnet"}.networkMap.${service.name};
      flush = service.flushInterval or false;
      proxyConfig =
        if flush
        then ''
          reverse_proxy ${netMap.hostName}:${toString netMap.port} {
            flush_interval -1
          }
        ''
        else "reverse_proxy ${netMap.hostName}:${toString netMap.port}";
    in
      pkgs.lib.nameValuePair "${netMap.vHost}" {
        extraConfig = ''
          bind tailscale/${service.name}
          encode zstd gzip
          ${proxyConfig}
        '';
      })
    services);

  mkCloudflareIngress = services:
    pkgs.lib.listToAttrs (map (service: let
      netMap = config.mySnippets.${service.location or "aylac-top"}.networkMap.${service.name};
    in
      pkgs.lib.nameValuePair netMap.vHost "http://${netMap.hostName}:${toString netMap.port}")
    services);

  pdsHomePage = ''
    hiii this is an ATProto PDS!! You will find my (ayla) account here!!
    i should probably put some cool ass art in here or maybe an actual homepage
    but having this by itself is fun

    most API routes are under /xrpc/
  '';
in {
  services = {
    cloudflared = {
      enable = true;
      certificateFile = config.age.secrets.cloudflareCertificate.path;
      tunnels = {
        "efe3d484-102d-4c58-bb17-ceaede4d7a4f" = {
          certificateFile = config.age.secrets.cloudflareCertificate.path;
          credentialsFile = config.age.secrets.cloudflareCredentials.path;
          default = "http_status:404";
          ingress =
            mkCloudflareIngress [
              {name = "forgejo";}
              {name = "glance";}
              {name = "ntfy";}
              {name = "vaultwarden";}
            ]
            // {
              "${config.mySnippets.aylac-top.networkMap.pds.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.pds.hostName}";
            };
        };
      };
    };

    caddy.virtualHosts =
      mkCaddyVHosts [
        {name = "audiobookshelf";}
        {name = "autobrr";}
        {name = "bazarr";}
        {name = "copyparty";}
        {name = "couchdb";}
        {name = "glance";}
        {
          name = "jellyfin";
          flushInterval = true;
        }
        {name = "jellyseerr";}
        {name = "karakeep";}
        {name = "miniflux";}
        {name = "prowlarr";}
        {name = "qbittorrent";}
        {name = "radarr";}
        {name = "radicale";}
        {name = "redlib";}
        {name = "sonarr";}
        {name = "webdav";}
      ]
      // {
        "http://${config.mySnippets.aylac-top.networkMap.pds.vHost}" = {
          extraConfig = ''
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
              reverse_proxy ${config.mySnippets.aylac-top.networkMap.pds.hostName}:${toString config.mySnippets.aylac-top.networkMap.pds.port}
            }
          '';
        };
      };

    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings = {
        PDS_HOSTNAME = config.mySnippets.aylac-top.networkMap.pds.vHost;
        # PDS_BSKY_APP_VIEW_URL = "https://bsky.zeppelin.social";
        # PDS_BSKY_APP_VIEW_DID = "did:web:bsky.zeppelin.social";
      };
    };

    #immich = {
    #  enable = true;
    #  host = "0.0.0.0";
    #  mediaLocation = "${dataDirectory}/immich";
    #  openFirewall = true;
    #  inherit (config.mySnippets.tailnet.networkMap.immich) port;
    #};

    audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      inherit (config.mySnippets.tailnet.networkMap.audiobookshelf) port;
    };

    vaultwarden = {
      enable = true;

      config = {
        DOMAIN = "https://${config.mySnippets.aylac-top.networkMap.vaultwarden.vHost}";
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_LOG = "critical";
        ROCKET_PORT = config.mySnippets.aylac-top.networkMap.vaultwarden.port;
        SIGNUPS_ALLOWED = false;
        ICON_SERVICE = "bitwarden";
        ICON_CACHE_TTL = 0;
        IP_HEADER = "CF-Connecting-IP";
      };

      environmentFile = config.age.secrets.vaultwarden.path;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      dataDir = "${dataDirectory}/jellyfin";
    };

    radicale = {
      enable = true;
      settings = {
        server = {
          hosts = ["0.0.0.0:${toString config.mySnippets.tailnet.networkMap.radicale.port}" "[::]:${toString config.mySnippets.tailnet.networkMap.radicale.port}"];
        };
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/var/lib/radicale/users";
          htpasswd_encryption = "autodetect";
        };
        storage = {
          filesystem_folder = "/var/lib/radicale/collections";
        };
      };
    };

    redlib = {
      enable = true;
      openFirewall = true;
      inherit (config.mySnippets.tailnet.networkMap.redlib) port;
      settings = {
        ENABLE_RSS = "on";
        REDLIB_DEFAULT_SHOW_NSFW = "on";
        REDLIB_DEFAULT_USE_HLS = "on";
        FULL_URL = "https://${config.mySnippets.tailnet.networkMap.redlib.vHost}";
      };
    };

    karakeep = {
      enable = true;

      extraEnvironment = rec {
        DISABLE_NEW_RELEASE_CHECK = "true";
        DISABLE_SIGNUPS = "true";
        OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
        INFERENCE_TEXT_MODEL = "gemini-2.5-flash";
        INFERENCE_IMAGE_MODEL = INFERENCE_TEXT_MODEL;
        EMBEDDING_TEXT_MODEL = INFERENCE_TEXT_MODEL;
        INFERENCE_CONTEXT_LENGTH = "600000";
        INFERENCE_LANG = "english";
        INFERENCE_NUM_WORKERS = "2";
        NEXTAUTH_URL = "https://${config.mySnippets.tailnet.networkMap.karakeep.vHost}";
        PORT = "7020";
      };
      environmentFile = config.age.secrets.gemini.path;
    };

    miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux.path;
      config = {
        BATCH_SIZE = 100;
        CLEANUP_FREQUENCY_HOURS = 48;
        LISTEN_ADDR = "${config.mySnippets.tailnet.networkMap.miniflux.hostName}:${toString config.mySnippets.tailnet.networkMap.miniflux.port}";
        BASE_URL = "https://${config.mySnippets.tailnet.networkMap.miniflux.vHost}";
        WEBAUTHN = "enabled";
      };
    };

    ntfy-sh = {
      enable = true;
      user = "ntfy";
      group = "ntfy";
      settings = {
        listen-http = ":${toString config.mySnippets.aylac-top.networkMap.ntfy.port}";
        base-url = "https://${config.mySnippets.aylac-top.networkMap.ntfy.vHost}";
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

    jellyseerr = {
      enable = true;
      inherit (config.mySnippets.tailnet.networkMap.jellyseerr) port;
      openFirewall = true;
    };

    copyparty = {
      enable = true;
      settings = {
        i = "0.0.0.0";
        p = [config.mySnippets.tailnet.networkMap.copyparty.port (config.mySnippets.tailnet.networkMap.copyparty.port + 1)];
        no-reload = true;
        ignored-flag = false;
      };
      accounts = {
        ayla = {
          passwordFile = config.age.secrets.copyparty.path;
        };
      };
      volumes = {
        "/" = {
          path = "/data/copyparty";
          access = {
            r = ["*"];
            A = ["ayla"];
          };
          flags = {
            fk = 4;
            scan = 480;
          };
        };
      };
    };

    webdav-server-rs = {
      enable = true;
      settings = {
        server.listen = ["0.0.0.0:${toString config.mySnippets.tailnet.networkMap.webdav.port}" "[::]:${toString config.mySnippets.tailnet.networkMap.webdav.port}"];
        accounts = {
          auth-type = "htpasswd.default";
          acct-type = "unix";
        };
        htpasswd.default = {
          htpasswd = pkgs.writeText "htpasswd" ''
            ayla:$2y$05$LD.VqJF.yVGsp.C3L6IJFO0SvYTeCKbGoGn70ZQaht4gxyEq2XbCS
          '';
        };
        location = [
          {
            route = ["/*path"];
            directory = "${dataDirectory}/webdav";
            handler = "filesystem";
            methods = ["webdav-rw"];
            autoindex = true;
            auth = "true";
          }
        ];
      };
    };

    couchdb = {
      inherit (config.mySnippets.tailnet.networkMap.couchdb) port;
      enable = true;
      bindAddress = "0.0.0.0";

      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };

        chttpd = {
          require_valid_user = true;
          max_http_request_size = 4294967296;
          enable_cors = true;
        };

        chttpd_auth = {
          require_valid_user = true;
          authentication_redirect = "/_utils/session.html";
        };

        httpd = {
          enable_cors = true;
          "WWW-Authenticate" = "Basic realm=\"couchdb\"";
          bind_address = "0.0.0.0";
        };

        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET,PUT,POST,HEAD,DELETE";
          max_age = 3600;
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/webdav 0755 webdav webdav - -"
  ];
}
