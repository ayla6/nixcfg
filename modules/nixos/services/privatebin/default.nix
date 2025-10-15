{
  config,
  lib,
  pkgs,
  ...
}: let
  name = "privatebin";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.aylac-top;
  service = network.networkMap.${name};

  package = pkgs.privatebin-ayla;
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

      nginx = {
        enable = true;
        recommendedTlsSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedGzipSettings = lib.mkDefault true;
        virtualHosts."${config.services.privatebin.virtualHost}" = {
          root = "${package}";
          locations = {
            "/" = {
              tryFiles = "$uri $uri/ /index.php?$query_string";
              index = "index.php";
              extraConfig = ''
                sendfile off;
              '';
            };
            "~ \\.php$" = {
              extraConfig = ''
                include ${config.services.nginx.package}/conf/fastcgi_params ;
                fastcgi_param SCRIPT_FILENAME $request_filename;
                fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
                fastcgi_pass unix:${config.services.phpfpm.pools.privatebin.socket};
              '';
            };
          };
          listen = [
            {
              addr = "localhost";
              inherit (service) port;
            }
          ];
        };
      };

      privatebin = {
        inherit package;
        enable = true;
        group = "nginx";
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
            defaultformatter = "plaintext";
            syntaxhighlightingtheme = "sons-of-obsidian";
            qrcode = true;
            template = "bootstrap-dark";
          };
          model.class = "Filesystem";
          model_options.dir = "/var/lib/privatebin/data";
        };
      };
    };
  };
}
