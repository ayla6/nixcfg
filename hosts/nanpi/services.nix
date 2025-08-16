{config, ...}: let
  dataDirectory = "/var/lib";
in {
  services = {
    pds = {
      enable = true;
      environmentFiles = [config.age.secrets.pds.path];
      pdsadmin.enable = true;
      settings = {
        PDS_HOSTNAME = config.mySnippets.aylac-top.networkMap.pds.vHost;
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

            "${config.mySnippets.aylac-top.networkMap.tangled-knot.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.tangled-knot.hostName}:${toString config.mySnippets.aylac-top.networkMap.tangled-knot.port}";

            "${config.mySnippets.aylac-top.networkMap.forgejo.vHost}" = "http://${config.mySnippets.aylac-top.networkMap.forgejo.hostName}:${toString config.mySnippets.aylac-top.networkMap.forgejo.port}";
            "${config.mySnippets.aylac-top.networkMap.forgejo.sshVHost}" = "ssh://${config.mySnippets.aylac-top.networkMap.forgejo.hostName}:2222";
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

    # because of the lack of forwarding the ssh because of the tunnel, repo origins have to be added like this, and nobody can pull your repos
    # git@nanpi:did\:plc\:3c6vkaq7xf5kz3va3muptjh5/nixcfg
    # you can also ln -s the did to your user name, letting you do git@nanpi:aylac.top/nixcfg
    # as opposed to git@knot.aylac.top:aylac.top/nixcfg
    tangled-knot = {
      enable = true;
      openFirewall = false;
      server = {
        hostname = config.mySnippets.aylac-top.networkMap.tangled-knot.vHost;
        listenAddr = "0.0.0.0:${toString config.mySnippets.aylac-top.networkMap.tangled-knot.port}";
        secretFile = config.age.secrets.tangled-knot.path;
      };
    };
  };
}
