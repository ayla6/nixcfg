# this was kind of the config used for it, ended up not using it because i had gotten confused about something, but the end result was the same so who cares
# also if you're reading this never use nano to write a password file to use in one of these because luks counts the newline nano forces on you as a character
{
  config,
  lib,
  ...
}: {
  options.myDisko = {
    installDrive = lib.mkOption {
      description = "Disk to install NixOS to.";
      default = "/dev/disk/by-id/ata-ADATA_IM2S3338-128GD2_5J3020000635";
      type = lib.types.str;
    };
    dataDrive = lib.mkOption {
      description = "Data disk.";
      default = "/dev/disk/by-id/ata-WDC_WD10SPZX-24Z10_WD-WXJ1A891NRKE";
      type = lib.types.str;
    };
  };

  config = {
    assertions = [
      {
        assertion = config.myDisko.installDrive != "";
        message = "config.myDisko.installDrive cannot be empty.";
      }
    ];

    disko.devices = {
      disk = {
        ssd = {
          type = "disk";
          device = config.myDisko.installDrive;

          content = {
            type = "gpt";

            partitions = {
              ESP = {
                content = {
                  format = "vfat";

                  mountOptions = [
                    "defaults"
                    "umask=0077"
                  ];

                  mountpoint = "/boot";
                  type = "filesystem";
                };

                size = "1024M";
                type = "EF00";
              };

              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";

                  content = {
                    type = "btrfs";
                    extraArgs = ["-f"];

                    subvolumes = {
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = ["compress=zstd" "noatime"];
                      };

                      ".snapshots" = {
                        mountOptions = ["compress=zstd" "noatime"];
                        mountpoint = "/home/.snapshots";
                      };

                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["compress=zstd" "noatime"];
                      };

                      "@" = {
                        mountpoint = "/";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                    };
                  };
                };
              };
            };
          };
        };
        harddrive = {
          type = "disk";
          device = config.myDisko.dataDrive;

          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted_harddrive";

                  content = {
                    type = "btrfs";
                    extraArgs = ["-f"];

                    subvolumes = {
                      "@data" = {
                        mountpoint = "/data";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
