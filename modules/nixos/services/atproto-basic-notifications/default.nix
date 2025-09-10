{
  config,
  lib,
  ...
}: let
  name = "atproto-basic-notifications";
  cfg = config.myNixOS.services.${name};
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name}";
  };

  config = lib.mkIf cfg.enable {
    services.atproto-basic-notifications = {
      enable = true;
      environmentFiles = [config.age.secrets.atp-notif.path];
      settings = {
        TARGET_DID = "did:plc:3c6vkaq7xf5kz3va3muptjh5";
      };
    };
  };
}
