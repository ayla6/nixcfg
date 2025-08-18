{
  lib,
  config,
  ...
}: {
  options.myNixOS.services.dnsmasq.enable = lib.mkEnableOption "dnsmasq";

  config = lib.mkIf config.myNixOS.services.dnsmasq.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "127.0.0.1";
        cache-size = 1000;
        no-resolv = true;

        server = ["100.100.100.100"];

        min-cache-ttl = 3600;
        max-cache-ttl = 172800;
      };
    };
    services.tailscale.extraUpFlags = ["--accept-dns=false"];
    networking.resolvconf.useLocalResolver = true;
  };
}
