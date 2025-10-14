{
  config,
  lib,
  ...
}: let
  name = "privatebin";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.aylac-top;
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
      cloudflared.tunnels."${network.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = "http://localhost:${toString service.port}";
      };

      nginx.virtualHosts."${config.services.privatebin.virtualHost}".listen = [
        {
          addr = "localhost";
          inherit (service) port;
        }
      ];

      privatebin = {
        enable = true;
        enableNginx = true;
        settings = {
          main = {
            name = "ayla's trashbin";
            basepath = "https://${service.vHost}/";
            discussion = true;
            opendiscussion = false;
            discussiondatedisplay = true;
            password = true;
            fileupload = true;
            burnafterreadingselected = false;
            defaultformatter = "syntaxhighlighting";
            syntaxhighlightingtheme = "sons-of-obsidian";
            qrcode = true;
            template = "bootstrap5";
          };
          model.class = "Filesystem";
          model_options.dir = "/var/lib/privatebin/data";
        };
      };
    };
  };
}
