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

        users.users.git.openssh.authorizedKeys.keyFiles =
          lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
          # right now this config is fine but if i ever get another machine i daily drive or a build server i need to do something else here
          (lib.filter (file:
            if config.networking.hostName == "morgana"
            then "ayla_m23.pub" == file
            else (lib.elem file ["ayla_morgana.pub" "ayla_23.pub"]))
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));

        services.tangled-knot = {
          enable = true;
          openFirewall = cfg.autoProxy;
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
