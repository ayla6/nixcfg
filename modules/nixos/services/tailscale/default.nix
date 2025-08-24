{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";

    authKeyFile = lib.mkOption {
      description = "Key file to use for authentication";
      default = config.age.secrets.tailscaleAuthKey.path or null;
      type = lib.types.nullOr lib.types.path;
    };

    enableCaddy = lib.mkOption {
      description = "Whether to serve supported local services on Tailnet with Caddy.";
      default = true;
      type = lib.types.bool;
    };

    operator = lib.mkOption {
      description = "Tailscale operator name";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.tailscale.enable {
    assertions = [
      {
        assertion = config.myNixOS.services.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    age.secrets.caddy.file = "${self.inputs.secrets}/caddy.age";

    home-manager.sharedModules = [
      {
        programs.gnome-shell.extensions = [
          {package = pkgs.gnomeExtensions.tailscale-qs;}
        ];
      }
    ];

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    services.caddy = lib.mkIf config.myNixOS.services.tailscale.enableCaddy {
      enable = true;

      virtualHosts = {
        "${config.networking.hostName}.${config.mySnippets.tailnet.name}".extraConfig = let
          syncthing = ''
            redir /syncthing /syncthing/
            handle_path /syncthing/* {
              reverse_proxy localhost:8384 {
                header_up Host localhost
              }
            }
          '';
        in
          lib.concatLines (
            lib.optional config.services.syncthing.enable syncthing
          );
      };
    };

    services.tailscale = {
      enable = true;
      inherit (config.myNixOS.services.tailscale) authKeyFile;

      extraUpFlags =
        ["--ssh"]
        ++ lib.optional (config.myNixOS.services.tailscale.operator != null)
        "--operator ${config.myNixOS.services.tailscale.operator}";

      extraSetFlags = ["--ssh"];

      openFirewall = true;
      permitCertUid = lib.mkIf config.services.caddy.enable "caddy";
      useRoutingFeatures = "both";
    };

    # who's the devil who made it impossible for this to work dude
    # this is so dirty
    systemd.services.tailscaled.serviceConfig.Environment = lib.mkAfter [
      "TS_NO_LOGS_NO_SUPPORT=true"
    ];
    networking.hosts = {
      "0.0.0.0" = ["log.tailscale.com"];
    };
  };
}
