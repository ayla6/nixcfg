{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf config.myNixOS.services.fail2ban.enable {
    environment.etc = {
      "fail2ban/filter.d/forgejo.conf".text = ''
        [Definition]
        failregex =  .*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>
        journalmatch = _SYSTEMD_UNIT=forgejo.service
      '';

      "fail2ban/filter.d/vaultwarden.conf".text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=vaultwarden.service
      '';

      "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
        ignoreregex =
        journalmatch = _SYSTEMD_UNIT=vaultwarden.service
      '';
    };

    services.fail2ban = {
      enable = true;
      ignoreIP = ["100.64.0.0/10"];
      bantime = "24h";
      bantime-increment.enable = true;
    };
  };
}
