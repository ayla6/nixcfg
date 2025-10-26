{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.myNixOS.profiles.arr;

  netMap = config.mySnippets.tailnet.networkMap;
in {
  options.myNixOS.profiles.arr = {
    enable = lib.mkEnableOption "*arr services";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib";
      description = "The directory where *arr stores its data files.";
    };

    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "auto proxy the *arrs";
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      age.secrets.autobrr.file = "${self.inputs.secrets}/autobrr.age";

      services = {
        caddy.virtualHosts = lib.mkIf cfg.autoProxy {
          "${netMap.autobrr.vHost}".extraConfig = ''
            bind tailscale/autobrr
            encode zstd gzip
            reverse_proxy ${netMap.autobrr.hostName}:${toString netMap.autobrr.port}
          '';

          #"${netMap.bazarr.vHost}".extraConfig = ''
          #  bind tailscale/bazarr
          #  encode zstd gzip
          #  reverse_proxy ${netMap.bazarr.hostName}:${toString netMap.bazarr.port}
          #'';

          "${netMap.prowlarr.vHost}".extraConfig = ''
            bind tailscale/prowlarr
            encode zstd gzip
            reverse_proxy ${netMap.prowlarr.hostName}:${toString netMap.prowlarr.port}
          '';

          "${netMap.radarr.vHost}".extraConfig = ''
            bind tailscale/radarr
            encode zstd gzip
            reverse_proxy ${netMap.radarr.hostName}:${toString netMap.radarr.port}
          '';

          "${netMap.sonarr.vHost}".extraConfig = ''
            bind tailscale/sonarr
            encode zstd gzip
            reverse_proxy ${netMap.sonarr.hostName}:${toString netMap.sonarr.port}
          '';
        };

        autobrr = {
          enable = true;
          openFirewall = false; # Port: 7474
          secretFile = config.age.secrets.autobrr.path;
          settings = {
            host = "0.0.0.0";
            port = 7474;
          };
        };

        #bazarr = {
        #  enable = true;
        #  dataDir = "${cfg.dataDir}/bazarr";
        #  openFirewall = true; # Port: 6767
        #};

        #lidarr = {
        #  enable = true;
        #  dataDir = "${cfg.dataDir}/lidarr/.config/Lidarr";
        #  openFirewall = true; # Port: 8686
        #};

        prowlarr = {
          enable = true;
          # dataDir = "${cfg.dataDir}/prowlarr";
          openFirewall = false; # Port: 9696
        };

        radarr = {
          enable = true;
          dataDir = "${cfg.dataDir}/radarr/.config/Radarr/";
          openFirewall = false; # Port: 7878
        };

        sonarr = {
          enable = true;
          dataDir = "${cfg.dataDir}/sonarr/.config/NzbDrone/";
          openFirewall = false; # Port: 8989
        };

        #flaresolverr = {
        #  enable = true;
        #  openFirewall = true; # Port: 8191
        #};
      };

      systemd = {
        tmpfiles.rules = [
          #"d ${config.services.lidarr.dataDir} 0755 lidarr lidarr"
          "d ${config.services.radarr.dataDir} 0755 radarr radarr"
          "d ${config.services.readarr.dataDir} 0755 readarr readarr"
          "d ${config.services.sonarr.dataDir} 0755 sonarr sonarr"
          "d ${config.myNixOS.profiles.arr.dataDir}/autobrr 0755 autobrr autobrr"
        ];
      };
    })
  ];
}
