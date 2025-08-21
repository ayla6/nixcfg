{
  config,
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
  systemd.services.disk-space-check = {
    description = "Check for low disk space";
    script = ''
      #!${pkgs.bash}/bin/bash
      THRESHOLD=80
      USAGE=$(df --output=pcent / | tail -n 1 | tr -d ' %')
      if [ "$USAGE" -gt "$THRESHOLD" ]; then
        ${mkNotify {
        message = "CRITICAL: Disk space on / is at $USAGE% on ${config.networking.hostName}";
        channel = "network-status";
        priority = 5;
      }}
      fi
    '';
  };

  systemd.timers.disk-space-check = {
    description = "Run disk space check every hour";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
