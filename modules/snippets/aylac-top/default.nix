{lib, ...}: {
  options.mySnippets.aylac-top.networkMap = lib.mkOption {
    type = lib.types.attrs;
    description = "Hostnames, ports, and vHosts for aylac.top services.";

    default = {
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
    };
  };
}
