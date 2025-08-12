{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf config.myNixOS.services.fail2ban.enable {
    environment.etc = {
    };

    services.fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;
    };
  };
}
