{
  config,
  lib,
  pkgs,
  ...
}: let
  name = "radicale";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
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

      radicale = {
        enable = true;
        settings = {
          server = {
            hosts = ["0.0.0.0:${toString service.port}" "[::]:${toString service.port}"];
          };
          auth = {
            type = "htpasswd";
            htpasswd_filename = "/var/lib/radicale/users";
            htpasswd_encryption = "autodetect";
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections";
            hook = ''${pkgs.git}/bin/git add -A && (${pkgs.git}/bin/git diff --cached --quiet || ${pkgs.git}/bin/git commit -m "Changes by \"%(user)s\"")'';
          };
        };
      };
    };
  };
}
