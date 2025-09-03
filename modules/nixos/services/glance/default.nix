{
  config,
  lib,
  ...
}: let
  name = "glance";
  cfg = config.myNixOS.services.${name};

  inherit (config.mySnippets) aylac-top;
  inherit (config.mySnippets) tailnet;

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

      glance = {
        enable = true;
        openFirewall = true;

        settings = {
          pages = [
            {
              name = service.vHost;
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
                          url = "https://${aylac-top.networkMap.forgejo.vHost}/";
                          check-url = "http://${aylac-top.networkMap.forgejo.hostName}:${toString aylac-top.networkMap.forgejo.port}/";
                          icon = "di:forgejo";
                        }
                        {
                          title = "PDS";
                          url = "https://${aylac-top.networkMap.pds.vHost}/";
                          check-url = "http://${aylac-top.networkMap.pds.hostName}:${toString aylac-top.networkMap.pds.port}/";
                          icon = "di:bluesky";
                        }
                        {
                          title = "ntfy";
                          url = "https://${aylac-top.networkMap.ntfy.vHost}/";
                          check-url = "http://${aylac-top.networkMap.ntfy.hostName}:${toString aylac-top.networkMap.ntfy.port}/";
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
                          title = "Vaultwarden";
                          url = "https://${tailnet.networkMap.vaultwarden.vHost}/";
                          check-url = "http://${tailnet.networkMap.vaultwarden.hostName}:${toString tailnet.networkMap.vaultwarden.port}/";
                          icon = "di:vaultwarden";
                        }
                        {
                          title = "Karakeep";
                          url = "https://${tailnet.networkMap.karakeep.vHost}/";
                          check-url = "http://${tailnet.networkMap.karakeep.hostName}:${toString tailnet.networkMap.karakeep.port}/";
                          icon = "di:karakeep";
                        }
                        {
                          title = "Jellyfin";
                          url = "https://${tailnet.networkMap.jellyfin.vHost}/";
                          check-url = "http://${tailnet.networkMap.jellyfin.hostName}:${toString tailnet.networkMap.jellyfin.port}/web/index.html";
                          icon = "di:jellyfin";
                        }
                        {
                          title = "Jellyseerr";
                          url = "https://${tailnet.networkMap.jellyseerr.vHost}/";
                          check-url = "http://${tailnet.networkMap.jellyseerr.hostName}:${toString tailnet.networkMap.jellyseerr.port}/";
                          icon = "di:jellyseerr";
                        }
                        {
                          title = "Sonarr";
                          url = "https://${tailnet.networkMap.sonarr.vHost}/";
                          check-url = "http://${tailnet.networkMap.sonarr.hostName}:${toString tailnet.networkMap.sonarr.port}/";
                          icon = "di:sonarr";
                        }
                        {
                          title = "Radarr";
                          url = "https://${tailnet.networkMap.radarr.vHost}/";
                          check-url = "http://${tailnet.networkMap.radarr.hostName}:${toString tailnet.networkMap.radarr.port}/";
                          icon = "di:radarr";
                        }
                        {
                          title = "Prowlarr";
                          url = "https://${tailnet.networkMap.prowlarr.vHost}/";
                          check-url = "http://${tailnet.networkMap.prowlarr.hostName}:${toString tailnet.networkMap.prowlarr.port}/";
                          icon = "di:prowlarr";
                        }
                        {
                          title = "Bazarr";
                          url = "https://${tailnet.networkMap.bazarr.vHost}/";
                          check-url = "http://${tailnet.networkMap.bazarr.hostName}:${toString tailnet.networkMap.bazarr.port}/";
                          icon = "di:bazarr";
                        }
                        {
                          title = "Autobrr";
                          url = "https://${tailnet.networkMap.autobrr.vHost}/";
                          check-url = "http://${tailnet.networkMap.autobrr.hostName}:${toString tailnet.networkMap.autobrr.port}/";
                          icon = "di:autobrr";
                        }
                        {
                          title = "qBittorrent";
                          url = "https://${tailnet.networkMap.qbittorrent.vHost}/";
                          check-url = "http://${tailnet.networkMap.qbittorrent.hostName}:${toString tailnet.networkMap.qbittorrent.port}/";
                          icon = "di:qbittorrent";
                          alt-status-codes = [401];
                        }
                        {
                          title = "Uptime Kuma";
                          url = "https://${tailnet.networkMap.uptime-kuma.vHost}/";
                          check-url = "http://${tailnet.networkMap.uptime-kuma.hostName}:${toString tailnet.networkMap.uptime-kuma.port}/";
                          icon = "di:uptime-kuma";
                        }
                        {
                          title = "Radicale";
                          url = "https://${tailnet.networkMap.radicale.vHost}/";
                          check-url = "http://${tailnet.networkMap.radicale.hostName}:${toString tailnet.networkMap.radicale.port}/";
                          icon = "di:radicale";
                        }
                        {
                          title = "Copyparty";
                          url = "https://${tailnet.networkMap.copyparty.vHost}/";
                          check-url = "http://${tailnet.networkMap.copyparty.hostName}:${toString tailnet.networkMap.copyparty.port}/";
                          icon = "di:copyparty";
                        }
                        {
                          title = "Redlib";
                          url = "https://${tailnet.networkMap.redlib.vHost}/";
                          check-url = "http://${tailnet.networkMap.redlib.hostName}:${toString tailnet.networkMap.redlib.port}/";
                          icon = "di:redlib";
                        }
                        {
                          title = "Miniflux";
                          url = "https://${tailnet.networkMap.miniflux.vHost}/";
                          check-url = "http://${tailnet.networkMap.miniflux.hostName}:${toString tailnet.networkMap.miniflux.port}/";
                          icon = "di:miniflux";
                        }
                        {
                          title = "audiobookshelf";
                          url = "https://${tailnet.networkMap.audiobookshelf.vHost}/";
                          check-url = "http://${tailnet.networkMap.audiobookshelf.hostName}:${toString tailnet.networkMap.audiobookshelf.port}/";
                          icon = "di:audiobookshelf";
                        }
                      ];
                    }
                    {
                      type = "split-column";
                      max-columns = 3;
                      widgets = [
                        {
                          type = "hacker-news";
                          limit = 30;
                          collapse-after = 10;
                        }
                        {
                          type = "lobsters";
                          limit = 30;
                          collapse-after = 10;
                        }
                        {
                          type = "rss";
                          title = "Tildes";
                          limit = 30;
                          collapse-after = 10;
                          cache = "1h";
                          feeds = [
                            {
                              url = "https://tildes.net/topics.rss";
                              title = "tildes.net";
                            }
                          ];
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
            inherit (tailnet.networkMap.glance) port;
          };
        };
      };
    };
  };
}
