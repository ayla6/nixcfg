{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.tmpOnTmpfs = {
    enable = lib.mkEnableOption "have /tmp as a tmpfs";
    buildOnVarLib = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "build nix on /var/lib instead of /tmp";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.myNixOS.profiles.tmpOnTmpfs.enable {
      boot.tmp.useTmpfs = true;
    })
    (lib.mkIf (config.myNixOS.profiles.tmpOnTmpfs.enable && config.myNixOS.profiles.tmpOnTmpfs.buildOnVarLib) {
      nix.settings.build-dir = "/var/lib";
    })
  ];
}
