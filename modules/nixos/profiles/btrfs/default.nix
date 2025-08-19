{
  config,
  lib,
  pkgs,
  ...
}: let
  # Compute a list of Btrfs file systems (with mountPoint and device)
  btrfsFSDevices = let
    # Helper: does a device already appear in the accumulator?
    isDeviceInList = list: device:
      builtins.any (e: e.device == device) list;

    # Helper: keep only the first occurrence of each device
    uniqueDeviceList = lib.foldl' (
      acc: e:
        if isDeviceInList acc e.device
        then acc
        else acc ++ [e]
    ) [];
  in
    uniqueDeviceList (
      lib.mapAttrsToList (_: fs: {
        inherit (fs) mountPoint device;
      })
      (lib.filterAttrs (_: fs: fs.fsType == "btrfs") config.fileSystems)
    );

  # Create beesd.filesystems attrset keyed by device basename, with spec = device path
  beesdConfig = lib.listToAttrs (map (fs: {
      name = lib.strings.sanitizeDerivationName (baseNameOf fs.device);

      value = {
        # hashTableSizeMB = 2048;
        # this is ugly but who cares, i can't just get the size of the partition
        # basically it's like, if it's one /data and on morgana then for sure it's like a terabyte of data, if it's on nanpi then it's 512gb, anything else is my laptop's ssd, 128gb, so 16mb, but could also be the tiny 20gb jezebel disk, as it can't go lower than 16mb
        hashTableSizeMB =
          if config.networking.hostName == "morgana" && fs.mountPoint == "/data"
          then 128
          else if config.networking.hostName == "nanpi"
          then 64
          else 16;
        spec = fs.device;
        verbosity = "info";

        extraOptions = [
          "--loadavg-target"
          "1.0"
          "--thread-factor"
          "0.50"
        ];
      };
    })
    btrfsFSDevices);

  # Check if a btrfs /home entry exists
  hasHomeSubvolume =
    lib.hasAttr "/home" config.fileSystems
    && config.fileSystems."/home".fsType == "btrfs";
in {
  options.myNixOS.profiles.btrfs = {
    enable = lib.mkEnableOption "btrfs filesystem configuration";
    deduplicate = lib.mkEnableOption "deduplicate btrfs filesystems";
    snapshots = lib.mkEnableOption "enable snapper snapshots";
  };

  config = lib.mkIf config.myNixOS.profiles.btrfs.enable {
    boot.supportedFilesystems = ["btrfs"];
    environment.systemPackages = lib.optionals (config.services.xserver.enable && config.myNixOS.profiles.btrfs.snapshots) [pkgs.snapper-gui];

    services = lib.mkIf (btrfsFSDevices != []) {
      beesd.filesystems = lib.mkIf config.myNixOS.profiles.btrfs.deduplicate beesdConfig;
      btrfs.autoScrub.enable = true;

      snapper = lib.mkIf config.myNixOS.profiles.btrfs.snapshots {
        configs.home = lib.mkIf hasHomeSubvolume {
          ALLOW_GROUPS = ["users"];
          FSTYPE = "btrfs";
          SUBVOLUME = "/home";
          TIMELINE_CLEANUP = true;
          TIMELINE_CREATE = true;
        };

        filters = ''
          -.bash_profile
          -.bashrc
          -.cache
          -.config
          -.librewolf
          -.local
          -.mozilla
          -.nix-profile
          -.pki
          -.share
          -.snapshots
          -.thunderbird
          -.zshrc
        '';

        persistentTimer = true;
      };
    };
  };
}
