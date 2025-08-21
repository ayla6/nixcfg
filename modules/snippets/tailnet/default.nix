{
  config,
  lib,
  ...
}: {
  options.mySnippets.tailnet = {
    name = lib.mkOption {
      default = "cinnamon-in.ts.net";
      description = "Tailnet name.";
      type = lib.types.str;
    };

    networkMap = lib.mkOption {
      type = lib.types.attrs;
      description = "Hostnames, ports, and vHosts for ${config.mySnippets.tailnet.name} services.";

      default = {
        qbittorrent = {
          hostName = "nanpi";
          port = 8080;
          vHost = "qbittorrent.${config.mySnippets.tailnet.name}";
        };

        jellyfin = {
          hostName = "nanpi";
          port = 8096;
          vHost = "jellyfin.${config.mySnippets.tailnet.name}";
        };

        immich = {
          hostName = "nanpi";
          port = 2283;
          vHost = "immich.${config.mySnippets.tailnet.name}";
        };

        radicale = {
          hostName = "nanpi";
          port = 5232;
          vHost = "radicale.${config.mySnippets.tailnet.name}";
        };

        uptime-kuma = {
          hostName = "jezebel";
          port = 3008;
          vHost = "uptime-kuma.${config.mySnippets.tailnet.name}";
        };

        webdav = {
          hostName = "nanpi";
          port = 4918;
          vHost = "webdav.${config.mySnippets.tailnet.name}";
        };

        glance = {
          hostName = "nanpi";
          port = 9090;
          vHost = "glance.${config.mySnippets.tailnet.name}";
        };

        bazarr = {
          hostName = "nanpi";
          port = 6767;
          vHost = "bazarr.${config.mySnippets.tailnet.name}";
        };

        #lidarr = {
        #  hostName = "nanpi";
        #  port = 8686;
        #  vHost = "lidarr.${config.mySnippets.tailnet.name}";
        #};

        prowlarr = {
          hostName = "nanpi";
          port = 9696;
          vHost = "prowlarr.${config.mySnippets.tailnet.name}";
        };

        radarr = {
          hostName = "nanpi";
          port = 7878;
          vHost = "radarr.${config.mySnippets.tailnet.name}";
        };

        sonarr = {
          hostName = "nanpi";
          port = 8989;
          vHost = "sonarr.${config.mySnippets.tailnet.name}";
        };

        autobrr = {
          hostName = "nanpi";
          port = 7474;
          vHost = "autobrr.${config.mySnippets.tailnet.name}";
        };

        karakeep = {
          hostName = "nanpi";
          port = 7020;
          vHost = "karakeep.${config.mySnippets.tailnet.name}";
        };

        copyparty = {
          hostName = "nanpi";
          port = 3210;
          vHost = "copyparty.${config.mySnippets.tailnet.name}";
        };

        redlib = {
          hostName = "nanpi";
          port = 6605;
          vHost = "redlib.${config.mySnippets.tailnet.name}";
        };

        miniflux = {
          hostName = "nanpi";
          port = 6540;
          vHost = "miniflux.${config.mySnippets.tailnet.name}";
        };

        jellyseerr = {
          hostName = "nanpi";
          port = 5055;
          vHost = "jellyseerr.${config.mySnippets.tailnet.name}";
        };
      };
    };
  };
}
