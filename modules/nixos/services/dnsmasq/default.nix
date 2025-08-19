{
  lib,
  config,
  ...
}: {
  options.myNixOS.services.dnsmasq = {
    enable = lib.mkEnableOption "dnsmasq";
    longCaches = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Have really long cache times.";
    };
  };

  config = lib.mkIf config.myNixOS.services.dnsmasq.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "127.0.0.1";
        cache-size = 1000;
        no-resolv = true;

        server = ["100.100.100.100"];

        min-cache-ttl =
          if config.myNixOS.services.dnsmasq.longCaches
          then 3600
          else 300;
        max-cache-ttl =
          if config.myNixOS.services.dnsmasq.longCaches
          then 172800
          else 3600;
      };
    };
    services.tailscale.extraUpFlags = ["--accept-dns=false"];
    networking.resolvconf.useLocalResolver = true;
  };
}
