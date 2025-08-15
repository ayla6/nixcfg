{
  config,
  lib,
  ...
}: {
  options.myDisko.installDrive = lib.mkOption {
    description = "Disk to install NixOS to.";
    default = "/dev/vda";
    type = lib.types.str;
  };

  config = {
    assertions = [
      {
        assertion = config.myDisko.installDrive != "";
        message = "config.myDisko.installDrive cannot be empty.";
      }
    ];
    disko.devices = {
      disk.main = {
        type = "disk";
        device = config.myDisko.installDrive;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
      lvm_vg = {
        root_vg = {
          type = "lvm_vg";
          lvs = {
            root = {
              size = "100%FREE";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["noatime" "compress=zstd"];
                  };
                  "/nix" = {
                    mountOptions = ["subvol=nix" "noatime" "compress=zstd"];
                    mountpoint = "/nix";
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
