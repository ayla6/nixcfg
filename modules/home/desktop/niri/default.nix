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

  inherit (config.myHome.profiles) defaultApps colours;

  coloursNh = config.myHome.profiles.coloursNoHash;
  inherit (config.mySnippets) fonts;
in {
  imports = [inputs.niri.homeModules.niri];

  options.myHome.desktop.niri = {
    enable = lib.mkEnableOption "niri desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.niri.enable {
    myHome = {
      programs = {
        mpv.enable = true;
        foot.enable = true;
      };
      profiles.defaultApps = {
        enable = true;

        archiveViewer = {
          package = lib.mkDefault pkgs.file-roller;
          icon = lib.mkDefault "org.gnome.FileRoller";
        };
        audioPlayer = {
          package = lib.mkDefault config.programs.mpv.finalPackage;
          icon = lib.mkDefault "mpv";
        };
        fileManager = {
          package = lib.mkDefault pkgs.nautilus;
          icon = lib.mkDefault "org.gnome.Nautilus";
        };
        imageViewer = {
          package = lib.mkDefault pkgs.loupe;
          icon = lib.mkDefault "org.gnome.Loupe";
        };
        pdfViewer = {
          package = lib.mkDefault pkgs.papers;
          icon = lib.mkDefault "org.gnome.Papers";
        };
        videoPlayer = {
          package = lib.mkDefault config.programs.mpv.finalPackage;
          icon = lib.mkDefault "mpv";
        };
        terminal = {
          package = lib.mkDefault config.programs.foot.package;
          exec = lib.mkDefault "${config.programs.foot.package}/bin/footclient";
          icon = lib.mkDefault "foot";
          term = lib.mkDefault "xterm-256color";
          desktop = lib.mkDefault "footclient.desktop";
        };
        editor = {
          package = lib.mkDefault config.programs.helix.package;
          terminal = lib.mkDefault true;
          icon = lib.mkDefault "helix";
        };
        terminalEditor.package = lib.mkDefault config.programs.helix.package;
      };
    };

    home.packages = with pkgs; [
      xwayland-satellite
      nautilus
      wl-clipboard
      swaybg
      brightnessctl
      morewaita-icon-theme
      adw-gtk3
    ];

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
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 100;
          show-failed-attempts = true;
          color = coloursNh.background;
          line-color = coloursNh.accent;
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
      darkman = {
        enable = true;
        settings = {
          usegeoclue = true;
          portal = true;
          dbusserver = true;
        };
        darkModeScripts = {
          gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3-dark'"

            niri msg action do-screen-transition && ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
          '';
        };
        lightModeScripts = {
          gtk-theme = ''
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'adw-gtk3'"

            niri msg action do-screen-transition && ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
          '';
        };
      };

      gnome-keyring = {
        enable = true;
        components = ["pkcs11" "secrets" "ssh"];
      };

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
