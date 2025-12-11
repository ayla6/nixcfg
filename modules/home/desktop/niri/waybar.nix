{config, ...}: let
  inherit (config.myHome.profiles) colours;
  inherit (config.mySnippets) fonts;

  icons = {
    network = {
      disconnected = "󰤮 ";
      ethernet = "󰈀 ";
      strength = [
        "󰤟 "
        "󰤢 "
        "󰤥 "
        "󰤨 "
      ];
    };
    notification = {
      red-badge = "<span foreground='red'><sup></sup></span>";
      bell = "󰂚";
      bell-badge = "󱅫";
      bell-outline = "󰂜";
      bell-outline-badge = "󰅸";
    };
    volume = {
      source = "󱄠";
      muted = "󰝟";
      levels = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
    };
  };
in {
  enable = true;
  settings.mainBar = {
    layer = "top";
    modules-left = [
      "niri/workspaces"
    ];
    modules-center = [
      "clock#date"
      "clock"
    ];
    modules-right = [
      "network"
      "wireplumber"
      "idle_inhibitor"
      "custom/swaync"
    ];

    clock = {
      format = "{:%H:%M}";
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

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    wireplumber = {
      format = "{icon} {volume}%";
      format-muted = "${icons.volume.muted} {volume}%";
      format-icons = icons.volume.levels;
      tooltip = false;
      on-click = "wpctl set-default $(wpctl status | awk '/Sinks:/,/Sources:/ {if ($0 ~ /^[ \t]*[0-9]/ && $0 !~ /\\*/) {print $2; exit}}' | tr -d '.')";
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

  style = with colours; ''
    * {
      font-family: ${fonts.pixel.name}, ${fonts.monospace.name}, sans-serif;
      font-weight: bold;
      font-size: 12px;
      min-height: 0;
      padding: 0;
      margin: 0;
    }
    window#waybar {
      background-color: ${background};
      color: ${foreground};
      padding: 0;
    }
    #workspaces button {
      border-radius: 2px;
      color: ${foreground};
    }
    #workspaces button.active {
      background-color: ${light_accent};
      color: ${background};
    }
    #workspaces,
    #window,
    #clock,
    #network,
    #battery,
    #wireplumber,
    #idle_inhibitor,
    #custom-swaync {
      margin: 2px 4px;
      padding: 0 4px;
    }
  '';
}
