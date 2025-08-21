{config, ...}: {
  services.glance = {
    enable = true;
    openFirewall = true;

    settings = {
      pages = [
        {
          name = config.mySnippets.aylac-top.networkMap.glance.vHost;
          width = "slim";
          hide-desktop-navigation = true;
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Public Services";

                  sites = [
                    {
                      title = "Forgejo";
                      url = "https://${config.mySnippets.aylac-top.networkMap.forgejo.vHost}/";
                      check-url = "http://${config.mySnippets.aylac-top.networkMap.forgejo.hostName}:${toString config.mySnippets.aylac-top.networkMap.forgejo.port}/";
                      icon = "di:forgejo";
                    }
                    {
                      title = "PDS";
                      url = "https://${config.mySnippets.aylac-top.networkMap.pds.vHost}/";
                      check-url = "http://${config.mySnippets.aylac-top.networkMap.pds.hostName}:${toString config.mySnippets.aylac-top.networkMap.pds.port}/";
                      icon = "di:bluesky";
                    }
                    {
                      title = "Vaultwarden";
                      url = "https://${config.mySnippets.aylac-top.networkMap.vaultwarden.vHost}/";
                      check-url = "http://${config.mySnippets.aylac-top.networkMap.vaultwarden.hostName}:${toString config.mySnippets.aylac-top.networkMap.vaultwarden.port}/";
                      icon = "di:vaultwarden";
                    }
                    {
                      title = "ntfy";
                      url = "https://${config.mySnippets.aylac-top.networkMap.ntfy.vHost}/";
                      check-url = "http://${config.mySnippets.aylac-top.networkMap.ntfy.hostName}:${toString config.mySnippets.aylac-top.networkMap.ntfy.port}/";
                      icon = "di:ntfy";
                    }
                  ];
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Private Services";

                  sites = [
                    {
                      title = "Karakeep";
                      url = "https://${config.mySnippets.tailnet.networkMap.karakeep.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.karakeep.hostName}:${toString config.mySnippets.tailnet.networkMap.karakeep.port}/";
                      icon = "di:karakeep";
                    }
                    {
                      title = "Jellyfin";
                      url = "https://${config.mySnippets.tailnet.networkMap.jellyfin.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.jellyfin.hostName}:${toString config.mySnippets.tailnet.networkMap.jellyfin.port}/web/index.html";
                      icon = "di:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://${config.mySnippets.tailnet.networkMap.jellyseerr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.jellyseerr.hostName}:${toString config.mySnippets.tailnet.networkMap.jellyseerr.port}/";
                      icon = "di:jellyseerr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://${config.mySnippets.tailnet.networkMap.sonarr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.sonarr.hostName}:${toString config.mySnippets.tailnet.networkMap.sonarr.port}/";
                      icon = "di:sonarr";
                    }
                    {
                      title = "Radarr";
                      url = "https://${config.mySnippets.tailnet.networkMap.radarr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.radarr.hostName}:${toString config.mySnippets.tailnet.networkMap.radarr.port}/";
                      icon = "di:radarr";
                    }
                    #{
                    #  title = "Lidarr";
                    #  url = "https://${config.mySnippets.tailnet.networkMap.lidarr.vHost}/";
                    #  check-url = "http://${config.mySnippets.tailnet.networkMap.lidarr.hostName}:${toString config.mySnippets.tailnet.networkMap.lidarr.port}/";
                    #  icon = "di:lidarr";
                    #}
                    {
                      title = "Prowlarr";
                      url = "https://${config.mySnippets.tailnet.networkMap.prowlarr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.prowlarr.hostName}:${toString config.mySnippets.tailnet.networkMap.prowlarr.port}/";
                      icon = "di:prowlarr";
                    }
                    {
                      title = "Bazarr";
                      url = "https://${config.mySnippets.tailnet.networkMap.bazarr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.bazarr.hostName}:${toString config.mySnippets.tailnet.networkMap.bazarr.port}/";
                      icon = "di:bazarr";
                    }
                    {
                      title = "Autobrr";
                      url = "https://${config.mySnippets.tailnet.networkMap.autobrr.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.autobrr.hostName}:${toString config.mySnippets.tailnet.networkMap.autobrr.port}/";
                      icon = "di:autobrr";
                    }
                    {
                      title = "qBittorrent";
                      url = "https://${config.mySnippets.tailnet.networkMap.qbittorrent.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.qbittorrent.hostName}:${toString config.mySnippets.tailnet.networkMap.qbittorrent.port}/";
                      icon = "di:qbittorrent";
                      alt-status-codes = [401];
                    }
                    {
                      title = "Uptime Kuma";
                      url = "https://${config.mySnippets.tailnet.networkMap.uptime-kuma.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.tailnet.networkMap.uptime-kuma.port}/";
                      icon = "di:uptime-kuma";
                    }
                    {
                      title = "Radicale";
                      url = "https://${config.mySnippets.tailnet.networkMap.radicale.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.radicale.hostName}:${toString config.mySnippets.tailnet.networkMap.radicale.port}/";
                      icon = "di:radicale";
                    }
                    {
                      title = "Copyparty";
                      url = "https://${config.mySnippets.tailnet.networkMap.copyparty.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.copyparty.hostName}:${toString config.mySnippets.tailnet.networkMap.copyparty.port}/";
                      icon = "di:copyparty";
                    }
                    {
                      title = "Redlib";
                      url = "https://${config.mySnippets.tailnet.networkMap.redlib.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.redlib.hostName}:${toString config.mySnippets.tailnet.networkMap.redlib.port}/";
                      icon = "di:redlib";
                    }
                    {
                      title = "Miniflux";
                      url = "https://${config.mySnippets.tailnet.networkMap.miniflux.vHost}/";
                      check-url = "http://${config.mySnippets.tailnet.networkMap.miniflux.hostName}:${toString config.mySnippets.tailnet.networkMap.miniflux.port}/";
                      icon = "di:miniflux";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];

      server = {
        host = "0.0.0.0";
        inherit (config.mySnippets.tailnet.networkMap.glance) port;
      };
    };
  };
}
