{
  pkgs,
  config,
  ...
}: let
  notifyOnUnplugScript = ''
    #!${pkgs.bash}/bin/bash
    LOGIN=$(cat "${config.age.secrets.ntfyAuto.path}")

    ${pkgs.curl}/bin/curl -u $LOGIN \
    -H "X-Priority: 5" \
      -d "ME YOUR CHILD ${config.networking.hostName} WAS UNPLUGGED FROM THE CHARGER HELP ME" \
      https://${config.mySnippets.aylac-top.networkMap.ntfy.vHost}/network-status
  '';
in {
  systemd.services.notify-on-unplug = {
    description = "Sends a notification when the computer is unplugged from the charger.";
    after = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "notify-on-unplug" notifyOnUnplugScript;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{online}=="0", TAG+="systemd", ENV{SYSTEMD_WANTS}="notify-on-unplug.service"
  '';
}
