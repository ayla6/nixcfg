{
  config,
  lib,
  self,
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
      cloudflared.tunnels."${network.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = "http://localhost:${toString service.port}";
      };
    };

    containers.tangled-knot = {
      autoStart = true;
      config = {
        imports = [self.inputs.tangled-core.nixosModules.knot];

        programs.ssh.knownHosts = config.mySnippets.ssh.knownHosts;

        services.openssh = {
          ports = [service.sshPort];
          settings = {
            PasswordAuthentication = false;
            PubkeyAuthentication = true;
          };
        };

        services.tangled-knot = {
          enable = true;
          stateDir = "/var/lib/knot";
          server = {
            owner = "did:plc:3c6vkaq7xf5kz3va3muptjh5";
            hostname = service.vHost;
            listenAddr = "localhost:${toString service.port}";
          };
        };

        system.stateVersion = "25.11";
      };
    };
  };
}
