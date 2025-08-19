{
  config,
  lib,
  ...
}: {
  options = {
    mySnippets.restic = lib.mkOption {
      type = lib.types.attrs;
      description = "Default restic backup settings shared across backup jobs.";

      default = {
        extraBackupArgs = [
          "--cleanup-cache"
          "--compression auto"
          "--no-scan"
        ];

        inhibitsSleep = true;
        initialize = true;
        passwordFile = config.age.secrets.resticPassword.path;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 3"
        ];

        rcloneConfigFile = config.age.secrets.rclone.path;

        timerConfig = {
          OnCalendar = "*-*-* 02:00:00";
          #OnCalendar = "*-*-* 02,14:00:00";
          #OnCalendar = "*-*-* 03:14:00";
          Persistent = true;
          RandomizedDelaySec = "600";
        };
      };
    };
  };
}
