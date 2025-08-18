{lib, ...}: {
  options.mySnippets.aylac-top.networkMap = lib.mkOption {
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

      uptime-kuma = {
        # Only used for status pages
        hostName = "jezebel";
        port = 3008;
      };
    };
  };
}
