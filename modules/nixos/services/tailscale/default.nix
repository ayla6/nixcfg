{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";
  };

  config = lib.mkIf config.myNixOS.services.tailscale.enable (
    lib.mkMerge [
      (lib.mkIf config.myNixOS.desktop.gnome.enable {
        environment.systemPackages = with pkgs; [
          gnomeExtensions.tailscale-qs
        ];
      })

      {
        services.tailscale = {
          enable = true;
          extraUpFlags = ["--ssh"];
          extraSetFlags = ["--advertise-exit-node"];
          extraDaemonFlags = ["--no-logs-no-support"];
          openFirewall = true;
          useRoutingFeatures = "both";
        };
      }
    ]
  );
}
