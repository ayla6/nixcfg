{
  config,
  lib,
  ...
}: let
  name = "couchdb";
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

      couchdb = {
        inherit (service) port;
        enable = true;
        bindAddress = "0.0.0.0";

        extraConfig = {
          couchdb = {
            single_node = true;
            max_document_size = 50000000;
          };

          chttpd = {
            require_valid_user = true;
            max_http_request_size = 4294967296;
            enable_cors = true;
          };

          chttpd_auth = {
            require_valid_user = true;
            authentication_redirect = "/_utils/session.html";
          };

          httpd = {
            enable_cors = true;
            "WWW-Authenticate" = "Basic realm=\"couchdb\"";
            bind_address = "0.0.0.0";
          };

          cors = {
            origins = "app://obsidian.md,capacitor://localhost,http://localhost";
            credentials = true;
            headers = "accept, authorization, content-type, origin, referer";
            methods = "GET,PUT,POST,HEAD,DELETE";
            max_age = 3600;
          };
        };
      };
    };
  };
}
