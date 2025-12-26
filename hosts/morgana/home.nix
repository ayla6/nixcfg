{
  self,
  pkgs,
  ...
}: let
  steamui = pkgs.writeShellScriptBin "steamui" ''
    # systemctl --user stop easyeffects

    # trap 'systemctl --user start easyeffects' EXIT

    export PROTON_USE_WOW64=1
    export PROTON_USE_NTSYNC=1
    export DXVK_FRAME_RATE=60

    ${pkgs.gamescope}/bin/gamescope -O HDMI-A-1 \
      --prefer-vk-device 0x8086:0x3ea0 \
      --backend wayland \
      --force-grab-cursor \
      -r 60 -w 1920 -h 1080 -W 1920 -H 1080 -f -e \
      --xwayland-count 2 -- \
      steam -gamepadui >/dev/null 2>&1
  '';
in {
  home-manager.users = {
    ayla = self.homeConfigurations.ayla // {config.home.packages = [steamui];};
  };
}
