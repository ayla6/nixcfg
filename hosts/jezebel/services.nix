{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@aylac.top";
  };

  services = {
    caddy = {
      email = "contact@aylac.top";

      virtualHosts = {
        "${config.mySnippets.tailnet.networkMap.uptime-kuma.vHost}" = {
          extraConfig = ''
            bind tailscale/uptime-kuma
            encode zstd gzip
            reverse_proxy ${config.mySnippets.tailnet.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.tailnet.networkMap.uptime-kuma.port}
          '';
        };

        "${config.mySnippets.aylac-top.networkMap.uptime-kuma.vHost}" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${config.mySnippets.aylac-top.networkMap.uptime-kuma.hostName}:${toString config.mySnippets.aylac-top.networkMap.uptime-kuma.port}
          '';
        };

        "${config.mySnippets.aylac-top.networkMap.glance.vHost}" = {
          extraConfig = ''
            encode gzip zstd
            reverse_proxy ${config.mySnippets.aylac-top.networkMap.glance.hostName}:${toString config.mySnippets.aylac-top.networkMap.glance.port}
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
