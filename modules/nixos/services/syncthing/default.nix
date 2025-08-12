{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing file syncing service.";

    certFile = lib.mkOption {
      description = "Path to the certificate file.";
      type = lib.types.path;
    };

    keyFile = lib.mkOption {
      description = "Path to the key file.";
      type = lib.types.path;
    };

    user = lib.mkOption {
      description = "User to run Syncthing as.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.syncthing.enable {
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    services = {
      caddy.virtualHosts =
        lib.mkIf
        (
          config.myNixOS.services.caddy.enable
          && config.myNixOS.services.tailscale.enable
        ) {
          "syncthing-${config.networking.hostName}.${config.mySnippets.tailnet.name}" = {
            extraConfig = ''
              bind tailscale/syncthing-${config.networking.hostName}
              reverse_proxy localhost:8384 {
                header_up Host localhost
              }
            '';
          };
        };

      syncthing = let
        cfg = config.myNixOS.services.syncthing;
        inherit (config.mySnippets.syncthing) devices;

        inherit (config.mySnippets.syncthing) folders;
      in {
        enable = true;
        cert = cfg.certFile;
        configDir = "${config.services.syncthing.dataDir}/.syncthing";
        dataDir = "/home/${cfg.user}";
        key = cfg.keyFile;
        openDefaultPorts = true;
        inherit (cfg) user;

        settings = {
          options = {
            localAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          inherit devices folders;
        };
      };
    };
  };
}
