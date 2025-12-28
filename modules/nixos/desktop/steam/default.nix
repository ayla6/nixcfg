{
  lib,
  pkgs,
  config,
  ...
}: let
  steam = lib.getExe pkgs.steam;

  steamui = pkgs.writeShellScriptBin "steamui" ''
    export PATH="${steamos-session-select}/bin:$PATH"

    # systemctl --user stop easyeffects

    # trap 'systemctl --user start easyeffects' EXIT

    export PROTON_USE_WOW64=1
    export PROTON_USE_NTSYNC=1
    export DXVK_FRAME_RATE=60

    export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
    export STEAM_USE_MANGOAPP=1
    export STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND=1
    export STEAM_MANGOAPP_HORIZONTAL_SUPPORTED=1

    export STEAM_ENABLE_VOLUME_HANDLER=1
    export SRT_URLOPEN_PREFER_STEAM=1
    export STEAM_MULTIPLE_XWAYLANDS=1
    export STEAM_GAMESCOPE_NIS_SUPPORTED=1
    export STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER=1
    export STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT=1
    export QT_IM_MODULE=steam
    export GTK_IM_MODULE=Steam

    ${lib.getExe pkgs.gamescope} -O HDMI-A-1 \
      --force-grab-cursor \
      --prefer-vk-device 0x8086:0x3ea0 \
      -r 60 -w 1920 -h 1080 -W 1920 -H 1080 -f -e \
      --xwayland-count 2 -- \
      ${steam} -gamepadui -steamos3 -steampal -steamdeck -cef-force-gpu >/dev/null 2>&1
  '';

  steamos-session-select = pkgs.writeShellScriptBin "steamos-session-select" ''
    ${steam} -shutdown
  '';
in {
  options.myNixOS.desktop.steam.enable = lib.mkEnableOption "Steam Big Picture";

  config = lib.mkIf config.myNixOS.desktop.steam.enable {
    environment.systemPackages = [steamui];
  };
}
