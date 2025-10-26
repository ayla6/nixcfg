{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.caddy.enable = lib.mkEnableOption "Caddy web server.";

  config = lib.mkIf config.myNixOS.services.caddy.enable {
    # TS_AUTHKEY and CF_API_TOKEN are defined in this file
    age.secrets.caddy.file = "${self.inputs.secrets}/caddy.age";
    networking.firewall.allowedTCPPorts = [80 443];

    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };

    services = {
      caddy = {
        enable = true;
        enableReload = false;
        environmentFile = config.age.secrets.caddy.path;

        globalConfig = ''
          tailscale {
            ephemeral true
          }
        '';

        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/tailscale/caddy-tailscale@v0.0.0-20250508175905-642f61fea3cc"];
          hash = "sha256-r9EDkhcgwK11dB46AV+Em8ZE6Aa7IDMwibDGkg3e/rc=";
        };
      };
      tailscale.permitCertUid = "caddy";
    };
    systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  };
}
