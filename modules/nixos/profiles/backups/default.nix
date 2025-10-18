{
  config,
  lib,
  pkgs,
  ...
}: let
  # idk how to share this across files :(
  mkNotify = {
    message,
    channel,
    priority ? 1,
  }: ''
    LOGIN=$(cat "${config.age.secrets.ntfyAuto.path}")
    ${pkgs.curl}/bin/curl -u $LOGIN \
    -H "X-Priority: ${toString priority}" \
      -d '${message}' \
      https://${config.mySnippets.aylac-top.networkMap.ntfy.vHost}/${channel}
  '';

  repoMap = {
    A = "rclone:a_gdrive:/backups/${config.networking.hostName}";
    B = "rclone:b_gdrive:/backups/${config.networking.hostName}";
  };
  mkRepo = {
    repo,
    service,
  }: "${repoMap.${repo}}/${service}";

  stop = {
    service,
    repoPath,
  }: ''
    #!${pkgs.bash}/bin/bash
    ${mkNotify {
      message = "Backing up ${service} to ${repoPath}, stopping service";
      channel = "network-status";
    }}
    ${pkgs.systemd}/bin/systemctl stop ${service}
  '';

  start = {
    service,
    repoPath,
  }: ''
    #!${pkgs.bash}/bin/bash
    ${mkNotify {
      message = "Back up for ${service} to ${repoPath} was completed (idk if successfully tho), starting service";
      channel = "network-status";
    }}
    ${pkgs.systemd}/bin/systemctl start ${service}
  '';

  prepareNoService = {
    service,
    repoPath,
  }: ''
    #!${pkgs.bash}/bin/bash
    ${mkNotify {
      message = "Backing up ${service} to ${repoPath}";
      channel = "network-status";
    }}
  '';

  cleanupNoService = {
    service,
    repoPath,
  }: ''
    #!${pkgs.bash}/bin/bash
    ${mkNotify {
      message = "Back up for ${service} to ${repoPath} was completed (idk if successfully tho)";
      channel = "network-status";
    }}
  '';

  mkBackups = services:
    lib.listToAttrs (map (service: let
      repoKey = service.repo or "A";
      repoPath = mkRepo {
        repo = repoKey;
        service = service.name;
      };
      systemdService =
        if service.containerised or false
        then "container@" + service.name
        else service.name;
      backupMode = service.backupMode or "stop"; # "stop", "notify", "quiet"

      commands =
        if backupMode == "stop"
        then {
          backupCleanupCommand = start {
            service = systemdService;
            inherit repoPath;
          };
          backupPrepareCommand = stop {
            service = systemdService;
            inherit repoPath;
          };
        }
        else if backupMode == "notify"
        then {
          backupCleanupCommand = cleanupNoService {
            service = service.name;
            inherit repoPath;
          };
          backupPrepareCommand = prepareNoService {
            service = service.name;
            inherit repoPath;
          };
        }
        else {};
    in
      lib.nameValuePair service.name (
        config.mySnippets.restic
        // {
          repository = repoPath;
          inherit (service) paths;
        }
        // commands
        // (service.extraConfig or {})
      )) (lib.filter (s: s.enable) services));
in {
  options.myNixOS.profiles.backups = {
    enable = lib.mkEnableOption "automatically back up enabled services";
  };

  config = lib.mkIf config.myNixOS.profiles.backups.enable {
    services.restic.backups = mkBackups [
      {
        name = "audiobookshelf";
        inherit (config.services.audiobookshelf) enable;
        paths = [config.services.audiobookshelf.dataDir];
      }
      {
        name = "bazarr";
        inherit (config.services.bazarr) enable;
        paths = [config.services.bazarr.dataDir];
      }
      {
        name = "couchdb";
        inherit (config.services.couchdb) enable;
        paths = [config.services.couchdb.databaseDir];
      }
      {
        name = "forgejo";
        containerised = true;
        inherit (config.myNixOS.services.forgejo) enable;
        paths = ["/var/lib/nixos-containers/forgejo${config.containers.forgejo.config.services.forgejo.stateDir}"];
        backupMode = "none";
      }
      # {
      #   name = "immich";
      #   inherit (config.services.immich) enable;
      #   name = "immich-server";
      #   paths = [
      #     "${config.services.immich.mediaLocation}/library"
      #     "${config.services.immich.mediaLocation}/profile"
      #     "${config.services.immich.mediaLocation}/upload"
      #     "${config.services.immich.mediaLocation}/backups"
      #   ];
      #   repo = "B";
      # }
      {
        name = "jellyfin";
        inherit (config.services.jellyfin) enable;
        paths = [config.services.jellyfin.dataDir];
      }
      {
        name = "lidarr";
        inherit (config.services.lidarr) enable;
        paths = [config.services.lidarr.dataDir];
      }
      {
        name = "ombi";
        inherit (config.services.ombi) enable;
        paths = [config.services.ombi.dataDir];
      }
      {
        # damn this is ugly
        name = "pds";
        containerised = true;
        inherit (config.myNixOS.services.pds) enable;
        paths = ["/var/lib/nixos-containers/pds${config.containers.pds.config.services.bluesky-pds.settings.PDS_DATA_DIRECTORY}"];
      }
      {
        name = "plex";
        inherit (config.services.plex) enable;
        paths = [config.services.plex.dataDir];
        extraConfig = {
          exclude = ["${config.services.plex.dataDir}/Plex Media Server/Plug-in Support/Databases"];
        };
      }
      {
        name = "postgresql";
        containerised = true;
        inherit (config.services.postgresql) enable;
        paths = [config.services.postgresql.dataDir];
        backupMode = "quiet";
      }
      {
        name = "prowlarr";
        inherit (config.services.prowlarr) enable;
        paths = [config.services.prowlarr.dataDir];
      }
      {
        name = "qbittorrent";
        inherit (config.services.qbittorrent) enable;
        paths = [config.services.qbittorrent.dataDir];
      }
      {
        name = "radarr";
        inherit (config.services.radarr) enable;
        paths = [config.services.radarr.dataDir];
      }
      {
        name = "readarr";
        inherit (config.services.readarr) enable;
        paths = [config.services.readarr.dataDir];
      }
      {
        name = "sonarr";
        inherit (config.services.sonarr) enable;
        paths = [config.services.sonarr.dataDir];
      }
      {
        name = "autobrr";
        inherit (config.services.autobrr) enable;
        paths = ["${config.myNixOS.profiles.arr.dataDir}/autobrr"];
      }
      {
        name = "tautulli";
        inherit (config.services.tautulli) enable;
        paths = [config.services.tautulli.dataDir];
      }
      {
        name = "uptime-kuma";
        inherit (config.services.uptime-kuma) enable;
        paths = ["/var/lib/uptime-kuma"];
      }
      {
        name = "vaultwarden";
        inherit (config.services.vaultwarden) enable;
        paths = ["/var/lib/vaultwarden"];
      }
      {
        name = "passwords";
        enable = builtins.elem config.networking.hostName config.mySnippets.syncthing.folders."Passwords".devices;
        paths = [config.mySnippets.syncthing.folders."Passwords".path];
        backupMode = "notify";
      }
      {
        name = "radicale";
        inherit (config.services.radicale) enable;
        paths = ["/var/lib/radicale"];
      }
      {
        name = "webdav";
        inherit (config.services.webdav-server-rs) enable;
        paths = ["/var/lib/webdav"];
        backupMode = "notify";
      }
      {
        name = "miniflux";
        inherit (config.services.miniflux) enable;
        paths = ["/var/lib/miniflux"];
      }
      {
        name = "jellyseerr";
        inherit (config.services.jellyseerr) enable;
        paths = ["/var/lib/jellyseerr"];
      }
      {
        name = "tangled-knot";
        inherit (config.services.tangled-knot) enable;
        paths = [config.services.tangled-knot.stateDir];
      }
    ];
  };
}
