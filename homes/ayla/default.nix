{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.fontix.homeModules.default
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          # development
          nodejs
          pnpm
          typescript
          ffmpeg-full
          luajit
          love

          # applications
          qbittorrent
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
          lmms
          nicotine-plus
          blender
          rclone
          rclone-browser
          bitwarden

          # gaming
          mgba
          melonDS
          openttd
          prismlauncher
          mindustry
        ];

        username = "ayla";
        stateVersion = "25.05";
      };

      programs.home-manager.enable = true;
      xdg.enable = true;

      myHome = {
        desktop = {
          gnome.enable = true;
        };

        programs = {
          anki.enable = true;
          chromium.enable = true;
          fastfetch.enable = true;
          firefox = {
            enable = true;
            mode = "sidebar";
          };
          zen-browser.enable = true;
          git.enable = true;
          helix.enable = true;
          micro.enable = true;
          mpv.enable = true;
          obs-studio.enable = true;
          ssh.enable = true;
          zed-editor.enable = true;
        };

        profiles = {
          shell.enable = true;
          defaultApps = {
            enable = true;
            forceMimeAssociations = true;
            archiveViewer.package = pkgs.file-roller;
            audioPlayer.package = config.programs.mpv.finalPackage;
            videoPlayer.package = config.programs.mpv.finalPackage;
            editor.package = pkgs.gnome-text-editor;
            fileManager.package = pkgs.nautilus;
            imageViewer.package = pkgs.loupe;
            pdfViewer.package = pkgs.papers;
            terminal.package = pkgs.ptyxis;
            terminalEditor.package = config.programs.micro.package;
            webBrowser.package = config.programs.firefox.finalPackage;
            #webBrowser = {
            #  exec = lib.getExe config.programs.zen-browser.finalPackage;
            #  package = config.programs.zen-browser.finalPackage;
            #};
          };
        };

        services = {
          aria2.enable = true;
        };
      };

      fontix = {
        fonts = {
          monospace = {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };

          sansSerif = {
            name = "Roboto Flex";
            package = pkgs.roboto-flex;
          };

          serif = {
            name = "Source Serif Pro";
            package = pkgs.source-serif-pro;
          };
        };

        sizes = {
          applications = 10;
          desktop = 10;
        };

        font-packages.enable = true;
        fontconfig.enable = true;
        gnome.enable = lib.mkIf pkgs.stdenv.isLinux true;
        gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;
      };

      systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.
    }

    (lib.mkIf pkgs.stdenv.isLinux {
      gtk.gtk3.bookmarks = lib.mkAfter [
        "file:///data/DCIM"
        "file:///data/ Data"
      ];

      home = {
        homeDirectory = "/home/ayla";

        packages = with pkgs; [
          # libraries
          libsecret
          wl-clipboard
          libnotify
          wl-clipboard
          libnotify

          # gaming
          wine
          steam-run
          lutris

          keepassxc
          fractal
          flare-signal
          audacious
          audacious-plugins
        ];
      };
    })
  ];
}
