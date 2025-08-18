{config, ...}: {
  services = {
    caddy = {
      virtualHosts = {
        "${config.mySnippets.tailnet.networkMap.uptime-kuma.vHost}" = {
          extraConfig = ''
            bind tailscale/uptime-kuma
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.tailnet.networkMap.uptime-kuma.port}
          '';
        };
      };
    };

    uptime-kuma = {
      enable = true;
      appriseSupport = true;

      settings = {
        PORT = toString config.mySnippets.aylac-top.networkMap.uptime-kuma.port;
        HOST = "0.0.0.0";
      };
    };
  };
}
