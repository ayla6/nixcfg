{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.nix-flatpak.homeManagerModules.nix-flatpak
    self.inputs.fontix.homeModules.default
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          # development
          ffmpeg-full
          love
          luajit
          #nodejs
          bun
          typescript

          # applications
          aseprite
          rclone
          #rclone-browser
          signal-desktop-bin
          bitwarden-desktop
          yt-dlp
          obsidian
        ];

        username = "ayla";
        stateVersion = "25.05";
      };

      programs.home-manager.enable = true;
      xdg.enable = true;

      myHome = {
        programs = {
          helium.enable = true;
          fastfetch.enable = true;
          firefox = {
            enable = true;
            mode = "sidebar";
          };
          git.enable = true;
          helix.enable = true;
          jujutsu.enable = true;
          micro.enable = true;
          mpv.enable = true;
          ssh.enable = true;
          zed-editor.enable = true;
        };

        profiles = {
          betterLocations.enable = true;
          shell.enable = true;
          fixMimeTypes.enable = true;
          defaultApps = {
            enable = true;
            forceMimeAssociations = true;
            archiveViewer.package = pkgs.file-roller;
            audioPlayer.package = config.programs.mpv.finalPackage;
            videoPlayer.package = config.programs.mpv.finalPackage;
            #editor.package = pkgs.gnome-text-editor;
            editor.package = pkgs.helix;
            fileManager.package = pkgs.nautilus;
            imageViewer.package = pkgs.loupe;
            pdfViewer.package = pkgs.papers;
            #terminal.package = pkgs.ptyxis;
            terminalEditor.package = config.programs.helix.package;
            webBrowser.package = config.programs.helium.package;
          };
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

          zip
          xz
          unzip
          p7zip
        ];
      };

      myHome = {
        desktop = {
          gnome.enable = true;
        };

        programs = {
          lutris.enable = true;
        };
      };

      services.flatpak = {
        packages = [
          # creative
          "io.lmms.LMMS"
          "org.blender.Blender"
          "org.gimp.GIMP"
          "org.inkscape.Inkscape"
          "org.kde.kdenlive"
          "org.kde.krita"
          "com.obsproject.Studio"

          # gaming
          "com.github.Anuken.Mindustry"
          "io.mgba.mGBA"
          "net.kuribo64.melonDS"
          "org.openttd.OpenTTD"
          "org.prismlauncher.PrismLauncher"

          # internet
          "org.nicotine_plus.Nicotine"
          "org.qbittorrent.qBittorrent"

          # media
          "com.github.iwalton3.jellyfin-media-player"
          "org.atheme.audacious"
          "org.freac.freac"
          "org.musicbrainz.Picard"
          "org.audacityteam.Audacity"

          # productivity
          "com.calibre_ebook.calibre"
          "net.ankiweb.Anki"

          # social (basically useless but)
          "im.dino.Dino"
          "org.gnome.Fractal"
          "org.squidowl.halloy"

          # utilities
          "com.github.tchx84.Flatseal"
          "org.keepassxc.KeePassXC"
        ];
        update.auto = {
          enable = true;
          onCalendar = "daily";
        };
      };
    })
  ];
}
