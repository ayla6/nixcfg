{config, ...}: let
  colors = config.mySnippets.colors;
  fonts = config.mySnippets.fonts;

  icons = {
    network.disconnected = "󰤮 ";
    network.ethernet = "󰈀 ";
    network.strength = [
      "󰤟 "
      "󰤢 "
      "󰤥 "
      "󰤨 "
    ];
    notification.red-badge = "<span foreground='red'><sup></sup></span>";
    notification.bell = "󰂚";
    notification.bell-badge = "󱅫";
    notification.bell-outline = "󰂜";
    notification.bell-outline-badge = "󰅸";
    volume.source = "󱄠";
    volume.muted = "󰝟";
    volume.levels = [
      "󰕿"
      "󰖀"
      "󰕾"
    ];
  };
in {
  enable = true;
  settings.mainBar = {
    layer = "top";
    modules-left = [
      "niri/workspaces"
      "niri/window"
    ];
    modules-center = [
      "clock#date"
      "clock"
    ];
    modules-right = [
      "network"
      "battery"
      "wireplumber"
      "idle_inhibitor"
      "custom/swaync"
    ];

    clock = {
      format = "{:%H:%M:%S}";
    };

    "clock#date" = {
      format = "{:%m-%d}";
    };

    network = {
      tooltip-format = "{ifname}";
      format-disconnected = icons.network.disconnected;
      format-ethernet = icons.network.ethernet;
      format-wifi = "{icon}";
      format-icons = icons.network.strength;
    };

    wireplumber = {
      format = "{icon} {volume}%";
      format-muted = "${icons.volume.muted} {volume}%";
      format-icons = icons.volume.levels;
      reverse-scrolling = 1;
      tooltip = false;
    };

    "wireplumber#source" = {
      format = icons.volume.source;
      tooltip = false;
    };

    "custom/swaync" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>";
        none = icons.notification.bell-outline;
        none-cc-open = icons.notification.bell;
        dnd-notification = "<span foreground='red'><sup></sup></span>";
        dnd-none = "";
        inhibited-notification = "<span foreground='red'><sup></sup></span>";
        inhibited-none = "";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      # exec = ''swaync-client -swb | jq -c 'if .class | .[]? // . | contains("cc-open") then .alt += "-cc-open" else . end' '';
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
  };

  style = with colors; ''
    * {
      font-family: ${fonts.sans_serif.name}, ${fonts.monospace.name}, sans-serif;
      font-weight: bold;
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background-color: #${background};
      color: #${foreground};
    }

    #workspaces,
    #window,
    #clock,
    #network,
    #battery,
    #wireplumber,
    #idle_inhibitor,
    #swaync {
    	margin: 0 4px;
    }
  '';
}
