{
  config,
  lib,
  ...
}: {
  options.myDisko.installDrive = lib.mkOption {
    description = "Disk to install NixOS to.";
    default = "/dev/sda";
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
      disk = {
        main = {
          type = "disk";
          device = config.myDisko.installDrive;

          content = {
            type = "gpt";

            partitions = {
              ESP = {
                content = {
                  format = "vfat";
                  mountOptions = ["umask=0077"];
                  mountpoint = "/boot";
                  type = "filesystem";
                };

                end = "1024M";
                priority = 1;
                start = "1M";
                type = "EF00";
              };

              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  extraArgs = ["-f"]; # Override existing partition
                };
              };
            };
          };
        };
      };
    };
  };
}
