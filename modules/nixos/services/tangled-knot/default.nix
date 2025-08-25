{
  config,
  lib,
  ...
}: let
  name = "tangled-knot";
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
      caddy.virtualHosts = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${service.hostName}:${toString service.port}
          '';
        };

        "ssh.${service.vHost}" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${service.hostName}:22
          '';
        };
      };

      tangled-knot = {
        enable = false;
        openFirewall = true;
        stateDir = "/home/git";
        server = {
          owner = "did:plc:3c6vkaq7xf5kz3va3muptjh5";
          hostname = service.vHost;
          listenAddr = "0.0.0.0:${toString service.port}";
        };
      };
    };
  };
}
