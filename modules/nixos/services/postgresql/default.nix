{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  name = "postgresql";
  cfg = config.myNixOS.services.${name};
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name} server";
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = {};
      description = "PostgreSQL databases.";
    };
  };

  config.containers.postgresql = lib.mkIf cfg.enable {
    autoStart = true;
    config = {
      imports = [self.nixosModules.locale-en-gb];

      services.postgresql = {
        enable = true;
        enableTCPIP = true;
        package = pkgs.postgresql_16;

        ensureDatabases = cfg.databases;
        ensureUsers =
          lib.map (dbName: {
            name = dbName;
            ensureDBOwnership = true;
          })
          cfg.databases;

        authentication = lib.concatStringsSep "\n" (
          lib.map (dbName: ''
            host ${dbName} ${dbName} samehost trust
          '')
          cfg.databases
        );
      };

      system.stateVersion = "25.11";
    };
  };
}
