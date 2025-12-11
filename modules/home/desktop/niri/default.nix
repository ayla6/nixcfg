{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  pidof = lib.getExe' pkgs.procps "pidof";
  niri = lib.getExe config.programs.niri.package;
  systemctl = config.systemd.user.systemctlPath;

  defaultApps = config.myHome.profiles.defaultApps;

  colours = config.myHome.profiles.colours;
  coloursNh = config.myHome.profiles.coloursNoHash;
  inherit (config.mySnippets) fonts;
in {
  imports = [inputs.niri.homeModules.niri];

  options.myHome.desktop.niri = {
    enable = lib.mkEnableOption "niri desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.niri.enable {
    myHome = {
      profiles.defaultApps.enable = true;
    };

    home.packages = with pkgs; [
      xwayland-satellite
      nautilus
      wl-clipboard
      swaybg
    ];

    xdg.portal = {
      config = {
        niri = {
          default = ["gnome" "gtk"];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };

    programs = {
      niri = {
        enable = true;
        package = pkgs.niri;
        settings = lib.mkMerge [
          (import ./binds.nix {inherit config lib;})
          ./input.nix
          (import ./spawn.nix {inherit config lib;})
          ./misc.nix
          (import ./layout.nix {inherit config;})
        ];
      };

      waybar = import ./waybar.nix {inherit config;};

      swaylock = {
        enable = true;
        settings = {
          color = "808080";
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 100;
          line-color = coloursNh.accent;
          show-failed-attempts = true;
        };
      };

      tofi = {
        enable = true;
        settings = with colours; {
          background-color = background;
          text-color = foreground;
          selection-color = foreground;
          font = fonts.pixel.name;
          font-size = 10;

          width = "100%";
          height = "100%";

          border-width = 1;
          border-color = accent;

          outline-width = 0;
          anchor = "center";

          history = true;

          terminal = defaultApps.terminal.exec;
          drun-launch = true;
        };
      };
    };

    services = {
      polkit-gnome.enable = true;
      swaync = {
        enable = true;
      };

      swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 600;
            command = "${pidof} swaylock || ${niri} msg action spawn -- swaylock";
          }
          {
            timeout = 630;
            command = "${pidof} swaylock && ${systemctl} suspend";
          }
        ];
        events = {
          "before-sleep" = "${niri} msg action power-off-monitors";
          "after-resume" = "${niri} msg action power-on-monitors";
        };
      };
    };
  };
}
