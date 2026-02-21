{
  config,
  lib,
  ...
}: let
  name = "octo-fiesta";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
  publicNetwork = config.mySnippets.aylac-top;
  publicService = publicNetwork.networkMap.${name};

  nv = config.mySnippets.tailnet.networkMap.navidrome;
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
    myNixOS.services = {
      podman.enable = true;
      navidrome.enable = true;
    };

    services = {
      # why the hell does nanpi resolve to 127.0.0.2 here ???
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}.${network.name}:${toString service.port}
      '';

      cloudflared.tunnels."${publicNetwork.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${publicService.vHost}" = "http://${service.hostName}.${network.name}:${toString service.port}";
      };
    };

    users = {
      groups.octo-fiesta = {};
      users.octo-fiesta = {
        group = "octo-fiesta";
        shell = "/bin/sh";
        isSystemUser = true;
        linger = true;
        home = "/var/lib/octo-fiesta";
        createHome = true;
        subUidRanges = [
          {
            startUid = 100000;
            count = 65536;
          }
        ];
        subGidRanges = [
          {
            startGid = 100000;
            count = 65536;
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [service.port];

    virtualisation.oci-containers.containers.octo-fiesta = {
      podman.user = "octo-fiesta";
      image = "ghcr.io/v1ck3s/octo-fiesta:dev";
      autoStart = true;
      ports = ["${toString service.port}:${toString service.port}"];
      volumes = ["/data/Music/Downloads:/app/downloads"];
      environment = {
        ASPNETCORE_URLS = "http://+:${toString service.port}";
        ASPNETCORE_ENVIRONMENT = "Production";
        Library__DownloadPath = "/app/downloads";

        Subsonic__Url = "http://host.containers.internal:${toString nv.port}";
        Subsonic__MusicService = "SquidWTF";
        Subsonic__StorageMode = "Permanent";
        Subsonic__CacheDurationHours = "1";
        Subsonic__EnableExternalPlaylists = "true";
        Subsonic__PlaylistsDirectory = "playlists";
        Subsonic__ExplicitFilter = "All";
        Subsonic__DownloadMode = "Album";
        Subsonic__AutoUpgradeQuality = "false";

        SquidWTF__Source = "Tidal";
        SquidWTF__Quality = "LOSSLESS";
        SquidWTF__InstanceTimeoutSeconds = "5";

        Deezer__Arl = "";
        Deezer__ArlFallback = "";
        Deezer__Quality = "";

        Qobuz__UserAuthToken = "";
        Qobuz__UserId = "";
        Qobuz__Quality = "";
      };
    };
  };
}
