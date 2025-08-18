{
  config,
  lib,
  ...
}: {
  options.mySnippets.tailnet = {
    name = lib.mkOption {
      default = "cinnamon-in.ts.net";
      description = "Tailnet name.";
      type = lib.types.str;
    };

    networkMap = lib.mkOption {
      type = lib.types.attrs;
      description = "Hostnames, ports, and vHosts for ${config.mySnippets.tailnet.name} services.";

      default = {
        qbittorrent = {
          hostName = "nanpi";
          port = 8080;
          vHost = "qbittorrent.${config.mySnippets.tailnet.name}";
        };

        jellyfin = {
          hostName = "nanpi";
          port = 8096;
          vHost = "jellyfin.${config.mySnippets.tailnet.name}";
        };

        immich = {
          hostName = "nanpi";
          port = 2283;
          vHost = "immich.${config.mySnippets.tailnet.name}";
        };

        radicale = {
          hostName = "nanpi";
          port = 5232;
          vHost = "radicale.${config.mySnippets.tailnet.name}";
        };

        uptime-kuma = {
          hostName = "jezebel";
          port = 3008;
          vHost = "uptime-kuma.${config.mySnippets.tailnet.name}";
        };
      };
    };
  };
}
