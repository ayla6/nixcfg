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
        no-resolv = false;
      };
    };
    networking.resolvconf.useLocalResolver = true;
  };
}
