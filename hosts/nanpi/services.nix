{
  config,
  pkgs,
  ...
}: let
  dataDirectory = "/var/lib";
in {
  services = {
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

    cloudflared = {
      enable = true;
      certificateFile = config.age.secrets.cloudflareCertificate.path;
      tunnels = {
        "efe3d484-102d-4c58-bb17-ceaede4d7a4f" = {
          certificateFile = config.age.secrets.cloudflareCertificate.path;
          credentialsFile = config.age.secrets.cloudflareCredentials.path;
          default = "http_status:404";
          ingress = {
            "${config.mySnippets.aylac-top.networkMap.pds.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.pds.hostName}:${toString config.mySnippets.aylac-top.networkMap.pds.port}";

            "${config.mySnippets.aylac-top.networkMap.vaultwarden.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.vaultwarden.hostName}:${toString config.mySnippets.aylac-top.networkMap.vaultwarden.port}";

            "${config.mySnippets.aylac-top.networkMap.forgejo.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.forgejo.hostName}:${toString config.mySnippets.aylac-top.networkMap.forgejo.port}";

            "${config.mySnippets.aylac-top.networkMap.ntfy.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.ntfy.hostName}:${toString config.mySnippets.aylac-top.networkMap.ntfy.port}";
          };
        };
      };
    };

    caddy.virtualHosts = {
      "${config.mySnippets.tailnet.networkMap.jellyfin.vHost}" = {
        extraConfig = ''
          bind tailscale/jellyfin
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.jellyfin.hostName}:${toString config.mySnippets.tailnet.networkMap.jellyfin.port} {
            flush_interval -1
          }
        '';
      };

      "${config.mySnippets.tailnet.networkMap.qbittorrent.vHost}" = {
        extraConfig = ''
          bind tailscale/qbittorrent
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.qbittorrent.hostName}:${toString config.mySnippets.tailnet.networkMap.qbittorrent.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.radicale.vHost}" = {
        extraConfig = ''
          bind tailscale/radicale
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.radicale.hostName}:${toString config.mySnippets.tailnet.networkMap.radicale.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.webdav.vHost}" = {
        extraConfig = ''
          bind tailscale/webdav
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.webdav.hostName}:${toString config.mySnippets.tailnet.networkMap.webdav.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.bazarr.vHost}" = {
        extraConfig = ''
          bind tailscale/bazarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.bazarr.hostName}:${toString config.mySnippets.tailnet.networkMap.bazarr.port}
        '';
      };

      #"${config.mySnippets.tailnet.networkMap.lidarr.vHost}" = {
      #  extraConfig = ''
      #    bind tailscale/lidarr
      #    encode zstd gzip
      #    reverse_proxy ${config.mySnippets.tailnet.networkMap.lidarr.hostName}:${toString config.mySnippets.tailnet.networkMap.lidarr.port}
      #  '';
      #};

      "${config.mySnippets.tailnet.networkMap.prowlarr.vHost}" = {
        extraConfig = ''
          bind tailscale/prowlarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.prowlarr.hostName}:${toString config.mySnippets.tailnet.networkMap.prowlarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.radarr.vHost}" = {
        extraConfig = ''
          bind tailscale/radarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.radarr.hostName}:${toString config.mySnippets.tailnet.networkMap.radarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.sonarr.vHost}" = {
        extraConfig = ''
          bind tailscale/sonarr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.sonarr.hostName}:${toString config.mySnippets.tailnet.networkMap.sonarr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.autobrr.vHost}" = {
        extraConfig = ''
          bind tailscale/autobrr
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.autobrr.hostName}:${toString config.mySnippets.tailnet.networkMap.autobrr.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.glance.vHost}" = {
        extraConfig = ''
          bind tailscale/glance
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.glance.hostName}:${toString config.mySnippets.tailnet.networkMap.glance.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.karakeep.vHost}" = {
        extraConfig = ''
          bind tailscale/karakeep
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.karakeep.hostName}:${toString config.mySnippets.tailnet.networkMap.karakeep.port}
        '';
      };

      "${config.mySnippets.tailnet.networkMap.copyparty.vHost}" = {
        extraConfig = ''
          bind tailscale/copyparty
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.copyparty.hostName}:${toString config.mySnippets.tailnet.networkMap.copyparty.port} {
            flush_interval -1
          }
        '';
      };

      "${config.mySnippets.tailnet.networkMap.redlib.vHost}" = {
        extraConfig = ''
          bind tailscale/redlib
          encode zstd gzip
          reverse_proxy ${config.mySnippets.tailnet.networkMap.redlib.hostName}:${toString config.mySnippets.tailnet.networkMap.redlib.port}
        '';
      };
    };

    # it's failing to build because it can't download some stuff
    # immich = {
    #   enable = true;
    #   host = "0.0.0.0";
    #   mediaLocation = "${dataDirectory}/immich";
    #   openFirewall = true;
    #   inherit (config.mySnippets.tailnet.networkMap.immich) port;
    # };

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
  };

  services.webdav-server-rs = {
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

  systemd.tmpfiles.rules = [
    "d /var/lib/webdav 0755 webdav webdav - -"
  ];
}
