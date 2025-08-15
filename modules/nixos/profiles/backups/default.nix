{
  config,
  lib,
  pkgs,
  ...
}: let
  backupDestinationA = "rclone:gdrive:/backups/${config.networking.hostName}";
  mkRepoA = service: "${backupDestinationA}/${service}";
  #backupDestinationB = "rclone:gdrive:/backups/${config.networking.hostName}";
  #mkRepoB = service: "${backupDestinationB}/${service}";
  stop = service: "${pkgs.systemd}/bin/systemctl stop ${service}";
  start = service: "${pkgs.systemd}/bin/systemctl start ${service}";
in {
  options.myNixOS.profiles.backups = {
    enable = lib.mkEnableOption "automatically back up enabled services to gdrive";
  };

  config = lib.mkIf config.myNixOS.profiles.backups.enable {
    services.restic.backups = {
      audiobookshelf = lib.mkIf config.services.audiobookshelf.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "audiobookshelf";
          backupPrepareCommand = stop "audiobookshelf";
          paths = [config.services.audiobookshelf.dataDir];
          repository = mkRepoA "audiobookshelf";
        }
      );

      bazarr = lib.mkIf config.services.bazarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "bazarr";
          backupPrepareCommand = stop "bazarr";
          paths = [config.services.bazarr.dataDir];
          repository = mkRepoA "bazarr";
        }
      );

      couchdb = lib.mkIf config.services.couchdb.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "couchdb";
          backupPrepareCommand = stop "couchdb";
          paths = [config.services.couchdb.databaseDir];
          repository = mkRepoA "couchdb";
        }
      );

      forgejo = lib.mkIf (config.services.forgejo.enable && config.services.forgejo.settings.storage.STORAGE_TYPE != "minio") (
        config.mySnippets.restic
        // {
          paths = [config.services.forgejo.stateDir];
          repository = mkRepoA "forgejo";
        }
      );

      # immich = lib.mkIf config.services.immich.enable (
      #   config.mySnippets.restic
      #   // {
      #     backupCleanupCommand = start "immich-server";
      #     backupPrepareCommand = stop "immich-server";
      #
      #     paths = [
      #       "${config.services.immich.mediaLocation}/library"
      #       "${config.services.immich.mediaLocation}/profile"
      #       "${config.services.immich.mediaLocation}/upload"
      #       "${config.services.immich.mediaLocation}/backups"
      #     ];
      #
      #     repository = mkRepoB "immich";
      #   }
      # );

      jellyfin = lib.mkIf config.services.jellyfin.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "jellyfin";
          backupPrepareCommand = stop "jellyfin";
          paths = [config.services.jellyfin.dataDir];
          repository = mkRepoA "jellyfin";
        }
      );

      lidarr = lib.mkIf config.services.lidarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "lidarr";
          backupPrepareCommand = stop "lidarr";
          paths = [config.services.lidarr.dataDir];
          repository = mkRepoA "lidarr";
        }
      );

      ombi = lib.mkIf config.services.ombi.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "ombi";
          backupPrepareCommand = stop "ombi";
          paths = [config.services.ombi.dataDir];
          repository = mkRepoA "ombi";
        }
      );

      pds = lib.mkIf config.services.pds.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "pds";
          backupPrepareCommand = stop "pds";
          paths = [config.services.pds.settings.PDS_DATA_DIRECTORY];
          repository = mkRepoA "pds";
        }
      );

      plex = lib.mkIf config.services.plex.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "plex";
          backupPrepareCommand = stop "plex";
          exclude = ["${config.services.plex.dataDir}/Plex Media Server/Plug-in Support/Databases"];
          paths = [config.services.plex.dataDir];
          repository = mkRepoA "plex";
        }
      );

      postgresql = lib.mkIf config.services.postgresql.enable (
        config.mySnippets.restic
        // {
          paths = [config.services.postgresql.dataDir];
          repository = mkRepoA "postgresql";
        }
      );

      prowlarr = lib.mkIf config.services.prowlarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "prowlarr";
          backupPrepareCommand = stop "prowlarr";
          paths = [config.services.prowlarr.dataDir];
          repository = mkRepoA "prowlarr";
        }
      );

      qbittorrent = lib.mkIf config.myNixOS.services.qbittorrent.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "qbittorrent";
          backupPrepareCommand = stop "qbittorrent";
          paths = [config.myNixOS.services.qbittorrent.dataDir];
          repository = mkRepoA "qbittorrent";
        }
      );

      radarr = lib.mkIf config.services.radarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "radarr";
          backupPrepareCommand = stop "radarr";
          paths = [config.services.radarr.dataDir];
          repository = mkRepoA "radarr";
        }
      );

      readarr = lib.mkIf config.services.readarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "readarr";
          backupPrepareCommand = stop "readarr";
          paths = [config.services.readarr.dataDir];
          repository = mkRepoA "readarr";
        }
      );

      sonarr = lib.mkIf config.services.sonarr.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "sonarr";
          backupPrepareCommand = stop "sonarr";
          paths = [config.services.sonarr.dataDir];
          repository = mkRepoA "sonarr";
        }
      );

      tautulli = lib.mkIf config.services.tautulli.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "tautulli";
          backupPrepareCommand = stop "tautulli";
          paths = [config.services.tautulli.dataDir];
          repository = mkRepoA "tautulli";
        }
      );

      uptime-kuma = lib.mkIf config.services.uptime-kuma.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "uptime-kuma";
          backupPrepareCommand = stop "uptime-kuma";
          paths = ["/var/lib/uptime-kuma"];
          repository = mkRepoA "uptime-kuma";
        }
      );

      vaultwarden = lib.mkIf config.services.vaultwarden.enable (
        config.mySnippets.restic
        // {
          backupCleanupCommand = start "vaultwarden";
          backupPrepareCommand = stop "vaultwarden";
          paths = ["/var/lib/vaultwarden"];
          repository = mkRepoA "vaultwarden";
        }
      );

      passwords = lib.mkIf (builtins.elem config.networking.hostName config.mySnippets.syncthing.folders."Passwords".devices) (
        config.mySnippets.restic
        // {
          paths = [config.mySnippets.syncthing.folders."Passwords".path];
          repository = mkRepoA "passwords";
        }
      );
    };
  };
}
