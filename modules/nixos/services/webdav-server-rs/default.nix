{
  config,
  lib,
  pkgs,
  ...
}: let
  name = "webdav";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};

  dataDirectory = "/var/lib";
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name} server";
    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      webdav-server-rs = {
        enable = true;
        settings = {
          server.listen = ["0.0.0.0:${toString service.port}" "[::]:${toString service.port}"];
          accounts = {
            auth-type = "htpasswd.default";
            acct-type = "unix";
          };
          htpasswd.default = {
            htpasswd = pkgs.writeText "htpasswd" ''
              ayla:$2y$05$LD.VqJF.yVGsp.C3L6IJFO0SvYTeCKbGoGn70ZQaht4gxyEq2XbCS
            '';
          };
          location = [
            {
              route = ["/*path"];
              directory = "${dataDirectory}/webdav";
              handler = "filesystem";
              methods = ["webdav-rw"];
              autoindex = true;
              auth = "true";
            }
          ];
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/webdav 0755 webdav webdav - -"
    ];
  };
}
