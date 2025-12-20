{
  self,
  pkgs,
  ...
}: let
  steamui = pkgs.writeShellScriptBin "steamui" ''
    systemctl --user stop easyeffects

    trap 'systemctl --user start easyeffects' EXIT

    ${pkgs.gamescope}/bin/gamescope -O HDMI-A-1 \
      --prefer-vk-device 0x8086:0x3ea0 \
      -r 60 -w 1920 -h 1080 -W 1920 -H 1080 -f -e \
      --xwayland-count 2 -- \
      steam -gamepadui >/dev/null 2>&1
  '';
in {
  home-manager.users = {
    ayla = self.homeConfigurations.ayla // {config.home.packages = [steamui];};
  };
}
