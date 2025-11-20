{
  config,
  pkgs,
  ...
}: let
  localRepo = "/external1/backups/${config.networking.hostName}";
  mirrorRepo = "/external1/mirrorBackups";
in {
  services.restic.backups = {
    pictures =
      config.mySnippets.restic
      // {
        paths = ["/data/DCIM" "/data/Pictures"];
        repository = "${localRepo}/pictures";
      };
  };

  systemd.services.rclone-mirror = {
    description = "Sync backups from cloud to local mirror";
    path = with pkgs; [rclone];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      set -e
      rclone --config ${config.age.secrets.rclone.path} sync "a_gdrive:/backups" "${mirrorRepo}/a"
      rclone --config ${config.age.secrets.rclone.path} sync "b_gdrive:/backups" "${mirrorRepo}/b"
    '';
  };

  systemd.timers.rclone-mirror = {
    description = "Run rclone mirror sync daily at 3am";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
