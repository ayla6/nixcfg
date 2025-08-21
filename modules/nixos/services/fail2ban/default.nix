{
  config,
  lib,
  pkgs,
  ...
}: let
  # idk how to share this across files :(
  mkNotify = {
    message,
    channel,
    priority ? 1,
  }: ''
    LOGIN=$(cat "${config.age.secrets.ntfyAuto.path}")
    ${pkgs.curl}/bin/curl -u $LOGIN \
    -H "X-Priority: ${toString priority}" \
      -d '${message}' \
      https://${config.mySnippets.aylac-top.networkMap.ntfy.vHost}/${channel}
  '';
in {
  options.myNixOS.services.fail2ban.enable = lib.mkEnableOption "fail2ban";

  config = lib.mkIf config.myNixOS.services.fail2ban.enable {
    environment.etc = {
      "fail2ban/action.d/ntfy.conf".text = ''
        [Definition]
        actionbanned = ${mkNotify {
          message = "Banned <ip> from <jail> at ${config.networking.hostName}";
          channel = "network-status";
          priority = 3;
        }}
      '';

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
      jails = {
        forgejo.settings = {
          action = "iptables-allports";
          bantime = 900;
          filter = "forgejo";
          findtime = 3600;
          maxretry = 4;
        };

        # HTTP basic-auth failures, 5 tries → 1-day ban
        nginx-http-auth = {
          settings = {
            enabled = true;
            maxretry = 5;
            findtime = 300;
            bantime = "24h";
          };
        };

        # Generic scanner / bot patterns (wp-login.php, sqladmin, etc.)
        nginx-botsearch = {
          settings = {
            enabled = true;
            maxretry = 10;
            findtime = 300;
            bantime = "24h";
          };
        };

        vaultwarden = ''
          enabled = true
          filter = vaultwarden
          port = 80,443,${toString config.services.vaultwarden.config.ROCKET_PORT}
          maxretry = 5
        '';

        vaultwarden-admin = ''
          enabled = true
          port = 80,443,${toString config.services.vaultwarden.config.ROCKET_PORT}
          filter = vaultwarden-admin
          maxretry = 3
          bantime = 14400
          findtime = 14400
        '';
      };
    };
  };
}
