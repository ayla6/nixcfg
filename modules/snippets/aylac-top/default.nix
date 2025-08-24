{
  lib,
  config,
  ...
}: {
  options.mySnippets.aylac-top = {
    cloudflareTunnel = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare Tunnel ID";
      default = "efe3d484-102d-4c58-bb17-ceaede4d7a4f";
    };

    networkMap = lib.mkOption {
      type = lib.types.attrs;
      description = "Hostnames, ports, and vHosts for aylac.top services.";

      default = {
        forgejo = {
          hostName = "nanpi";
          port = 3001;
          sshVHost = "ssh.aylac.top";
          vHost = "git.aylac.top";
        };

        pds = {
          hostName = "nanpi";
          port = 3000;
          vHost = "pds.aylac.top";
        };

        vaultwarden = {
          hostName = "nanpi";
          port = 8222;
          vHost = "vault.aylac.top";
        };

        ntfy = {
          hostName = "nanpi";
          port = 9024;
          vHost = "ntfy.aylac.top";
        };

        uptime-kuma = {
          inherit (config.mySnippets.tailnet.networkMap.uptime-kuma) hostName;
          inherit (config.mySnippets.tailnet.networkMap.uptime-kuma) port;
          vHost = "status.aylac.top";
        };

        glance = {
          inherit (config.mySnippets.tailnet.networkMap.glance) hostName;
          inherit (config.mySnippets.tailnet.networkMap.glance) port;
          vHost = "services.aylac.top";
        };
      };
    };
  };
}
