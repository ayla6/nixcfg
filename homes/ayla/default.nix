{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    self.homeModules.default
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          rclone
        ];

        username = "ayla";
      };

      programs.home-manager.enable = true;
      xdg.enable = true;

      myHome = {
        desktop = {
          gnome.enable = true;
        };

        programs = {
          chromium.enable = true;
          fastfetch.enable = true;
          firefox.enable = true;
          git.enable = true;
          micro.enable = true;
          mpv.enable = true;
          obs-studio.enable = true;
          zed-editor.enable = true;
          ssh.enable = true;
        };

        profiles = {
          shell.enable = true;
          defaultApps = {
            enable = true;
            forceMimeAssociations = true;
            audioPlayer.package = config.programs.mpv.finalPackage;
            videoPlayer.package = config.programs.mpv.finalPackage;
            editor.package = pkgs.gnome-text-editor;
            fileManager.package = pkgs.nautilus;
            imageViewer.package = pkgs.loupe;
            pdfViewer.package = pkgs.papers;
            terminal.package = pkgs.gnome-console;
            terminalEditor.package = config.programs.micro.package;
            webBrowser.package = config.programs.firefox.finalPackage;
          };
        };

        services = {
          aria2.enable = true;
        };

        themes = {
          #evergarden.enable = true;
          fonts.enable = false;
        };
      };
    }

    (lib.mkIf pkgs.stdenv.isLinux {
      gtk.gtk3.bookmarks = lib.mkAfter [
        "file://home/Data/DCMI"
        "file://home/Data"
      ];

      home = {
        homeDirectory = "/home/ayla";

        packages = with pkgs; [
          wl-clipboard
          libnotify

          # --- Development ---
          gcc
          nodejs
          pnpm
          typescript
          ffmpeg-full
          luajit
          love

          # --- Applications ---
          keepassxc
          libsecret
          qbittorrent
          flare-signal
          kdePackages.kdenlive
          krita
          gimp3
          yt-dlp
          aseprite
          inkscape
          jellyfin-media-player
          calibre
          picard
          freac
          audacious
          audacious-plugins
          lmms
          nicotine-plus

          # --- Gaming ---
          wine
          steam-run
          lutris
          mgba
          melonDS
          openttd
          prismlauncher
          mindustry
        ];

        stateVersion = "25.05";
        username = "ayla";
      };

      systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.
    })
  ];
}
