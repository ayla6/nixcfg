{config, ...}: let
  default_apps = config.myHome.profiles.defaultApps;
in {
  binds = with config.lib.niri.actions;
    {
      "Mod+Space".action = spawn "${config.programs.tofi.package}/bin/tofi-drun";

      "Mod+Return".action = spawn default_apps.terminal.exec;

      "Mod+Shift+Q".action = quit;

      "Mod+Q" = {
        action = close-window;
        repeat = false;
      };

      "Mod+N".action = focus-column-left;
      "Mod+E".action = focus-window-or-workspace-down;
      "Mod+I".action = focus-window-or-workspace-up;
      "Mod+O".action = focus-column-right;

      "Mod+Shift+N".action = move-column-left;
      "Mod+Shift+E".action = move-workspace-down;
      "Mod+Shift+I".action = move-workspace-up;
      "Mod+Shift+O".action = move-column-right;

      "Mod+A".action = focus-column-first;
      "Mod+T".action = focus-column-last;
      "Mod+Shift+A".action = move-column-to-first;
      "Mod+Shift+T".action = move-column-to-last;

      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;
      "Mod+Shift+1".action.move-column-to-workspace = [1];
      "Mod+Shift+2".action.move-column-to-workspace = [2];
      "Mod+Shift+3".action.move-column-to-workspace = [3];
      "Mod+Shift+4".action.move-column-to-workspace = [4];
      "Mod+Shift+5".action.move-column-to-workspace = [5];
      "Mod+Shift+6".action.move-column-to-workspace = [6];
      "Mod+Shift+7".action.move-column-to-workspace = [7];
      "Mod+Shift+8".action.move-column-to-workspace = [8];
      "Mod+Shift+9".action.move-column-to-workspace = [9];

      "Mod+R".action = consume-or-expel-window-left;
      "Mod+S".action = consume-or-expel-window-right;

      "F11".action = fullscreen-window;
      "Mod+Y".action = maximize-window-to-edges;
      "Mod+Shift+F".action = expand-column-to-available-width;
      "Mod+C".action = center-column;
      "Mod+Shift+C".action = center-visible-columns;
      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";

      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";

      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

      "Mod+W".action = toggle-column-tabbed-display;

      "Mod+Shift+S".action.screenshot = [];
      "Mod+Ctrl+S".action.screenshot-screen = [];
      "Mod+Alt+S".action.screenshot-window = [];

      "Mod+Shift+P".action = power-off-monitors;

      "Mod+Shift+L" = {
        allow-inhibiting = false;
        action = spawn "swaylock";
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+ -l 1.0";
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-";
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };

      "XF86AudioPlay" = {
        allow-when-locked = true;
        action = spawn-sh "playerctl play-pause";
      };
      "XF86AudioStop" = {
        allow-when-locked = true;
        action = spawn-sh "playerctl stop";
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action = spawn-sh "playerctl previous";
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action = spawn-sh "playerctl next";
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action = spawn "brightnessctl" "--class=backlight" "set" "+2.5%";
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action = spawn "brightnessctl" "--class=backlight" "set" "2.5%-";
      };
    }
    // (
      if config.myHome.programs.yazi.enable
      then {"Mod+F".action = spawn default_apps.terminal.exec "-e" "yazi";}
      else {}
    );
}
