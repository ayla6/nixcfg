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
          (import ./binds.nix {inherit config;})
          ./input.nix
          (import ./spawn.nix {inherit config lib;})
          ./misc.nix
          ./layout.nix
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
          line-color = "ffffff";
          show-failed-attempts = true;
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
        events = [
          {
            event = "before-sleep";
            command = "${niri} msg action power-off-monitors";
          }
          {
            event = "after-resume";
            command = "${niri} msg action power-on-monitors";
          }
        ];
      };
    };
  };
}
